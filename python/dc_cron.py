#!/usr/bin/env python
from __future__ import print_function

import os.path
import sqlalchemy
import sys

# assume datacat directory
# e.g.  /afs/slac.stanford.edu/u/gl/srs/datacat/dev/0.5/lib
# has been added to PATH or PYTHONPATH

from datacat import client_from_config_file

def get_db_engine(kwds):
    '''
    Argument is a dict with keys like 'host', 'database', etc.
    '''

    # Form URL
    db_url = sqlalchemy.engine.url.URL('mysql+mysqldb', **kwds)
    return sqlalchemy.create_engine(db_url)

def get_et_engine(dataSource='Prod'):
    '''
    Get an engine for the specified db allowing us to update as well as select
    '''
    connectFile = '.ssh/.et{}.cnf'.format(dataSource)
    connectFile = os.path.join(os.environ['HOME'], connectFile)

    kwds = {}
    try:
        with open(connectFile) as f:
            for line in f:
                (key, val) = line.split()
                kwds[key] = val
    except IOError:
        raise IOError, "Unable to open connect file" + connectFile

    return get_db_engine(kwds)

class RegisterDC():
    '''
    Registers groups of unregistered files, one eT activity at a time
    '''
    q_template='''
            select id, value, virtualPath, datatype, 
            schemaInstance from FilepathResultHarnessed where
            catalogKey is NULL and activityId={} order by id'''
    uq_template='''
            INSERT  into FilepathResultHarnessed (id, catalogKey, activityId)
            VALUES {} ON DUPLICATE KEY UPDATE catalogKey=VALUES(catalogKey)
            '''
    def __init__(self, engine):
        self.engine = engine

        #  Get datacata client
        self.dc_client = client_from_config_file()

    def register_file(self, dc_folder, basename, file_format, physical_path, 
                      datatype='LSSTSENSORTEST', site='SLAC'):
        # Check if folder already exists.  If not, create it
        if not self.dc_client.exists(dc_folder, site=site):
            self.dc_client.mkdir(dc_folder, parents=True)

        # Register
        dc_dataset = self.dc_client.create_dataset(dc_folder, basename, 
                                                   datatype, file_format, 
                                                   site=site,
                                                   resource=physical_path)
        return dc_dataset.pk

    def register_activity(self, activityId, debug=False):
        '''
        For each file belonging to the activity which is not already
        registered, register with data catalog and store catalog key in db

        Arguments
        ---------
        activityId   int    Activity whose outputs are to be registered

        Returns
        -------
        count of files processed

        '''
        # select id,value,...[and more] from FilepathResultHarnessed
        # where activityId=activity and catalogKey is NULL
        q = self.q_template.format(str(activityId))

        results = self.engine.execute(q)
        val_list = []    # used to store info for insert...update on duplicate
        
        count = 0
        row = results.fetchone()
        while row != None:
            count += 1

            #  compute a couple things
            folder, basename = os.path.split(row['virtualPath'])
            file_format = basename.split('.')[-1]
            key = self.register_file(folder, basename, file_format,
                                     row['value'])

            if debug:
                if count == 1:
                    print('catalog key: {}'.format(key))
                    print('folder: {}\nbasename: {}'.format(folder, basename))
                    print('file_format: {}\ndc path: {}'.format(file_format,
                                                            row['virtualPath']))
                    print('physical path: {}'.format(row['value']))
                    sys.stdout.flush()
            val_list.append("({},{},{})".format(str(row['id']), str(key), str(activityId)))
            row = results.fetchone()
              
        if count == 0: return 0
        sys.stdout.flush()

        values = ','.join(val_list)
        uq = self.uq_template.format(values)

        self.engine.execute('set sql_notes = 0')
        self.engine.execute(uq)

        return count

if __name__ == '__main__':
    # Can try it out with Raw, activity ids 
    # 1536 (3 files)   REGISTERED, DB UPDATED; no warnings :-)
    # 1537 (1 file)    REGISTERED; no db update because didn't have key
    # 1540 (20501)
    # 1541 (1)         REGISTERED, DB UPDATED; def value & unsafe stmt warnings
    # 1544 (20501)
    # 1545 (1)         REGISTERED, DB UPDATED def value warnings
    # 1550 (17751)     REGISTERED, DB UPDATED. 21 minutes with print statement
    # 1551 (1)         REGISTERED; hand DB UPDATE
    # 
    # 1554 (3)         tested with defaults defined in db table
    # 1555 (1)         tested with defaults defined in db table
    # 1558 (3)         tested --debug argument
    # 1559 (1)         tested default (debug is False)
    # 1562 (3)
    # 1563 (1)
    # 1566 (3)
    # 1567 (1)

    import argparse
    from datetime import datetime as dt
    TIME_TO_SECOND_FMT = '%Y-%m-%d %H:%M:%S'
    
    parser = argparse.ArgumentParser(
        description='Register files in data catalog for one harnessed job')
    parser.add_argument('--activity-id', type=int, required=True,
                        help='activity id of harnessed job')
    parser.add_argument('--db', required=True,
                        choices = ['Prod', 'Dev', 'Test', 'Raw'],
                        help='one of Prod, Dev, Test, Raw')
    parser.add_argument('--debug', action='store_true', default=False,
                        help='Write extra output to stdout')
    args = parser.parse_args()

    
                        
    engine = get_et_engine(dataSource=args.db)

    registrar = RegisterDC(engine)
    activity_id = args.activity_id
    print('Called with db={}, activity-id={}'.format(args.db, args.activity_id))
    print('Before register time is ',dt.now())
    sys.stdout.flush()
    cnt = registrar.register_activity(activity_id, debug=args.debug)
    print('After register time is ',dt.now())    
    sys.stdout.flush()
    print('Registered {cnt} files for activity {activity_id}'.format(**locals()))
