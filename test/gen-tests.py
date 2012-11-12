"""
this generates a a bunch of small include files
so that i can write tests just by writing new
procedures. ( it also generates the definitions )
"""
import os
topuse = open( 'run-tests.use', 'w' )
toprun = open( 'run-tests.run', 'w' )
for path in map( str.strip, os.popen( 'ls test_*.pas' )):
    name, _ = path.split( '.' )
    print >> topuse, ',', name ,
    subdef = open( name + '.def', 'w' )
    subdef.write( 'unit {0};\ninterface\n'.format( name ))
    for line in map( str.strip, open( path )):
        if line.startswith( 'procedure test_' ):
            print >> subdef, ' ', line
            print >> toprun, 'run( @%s.%s );' \
                % ( name, line.split(' ', 1 )[ 1 ][ : -1 ]) # strip ";"
    subdef.close()
topuse.close()
toprun.close()
