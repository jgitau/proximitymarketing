#!/bin/bash

function download_and_uncompress(){
    PACKAGE=$1
    VERSION=$2
    FOLDER=$3
    URL=$4

    echo "processing $PACKAGE"
    
    if [ ! -f $CWD/libs/$PACKAGE-$VERSION.tar.gz ]; then
	echo "Downloading"
	wget -O $CWD/libs/$PACKAGE-$VERSION.tar.gz $URL/$PACKAGE-$VERSION.tar.gz
    fi
    
    echo "extracting $PACKAGE"
    gunzip -c $CWD/libs/$PACKAGE-$VERSION.tar.gz | tar -x
    (cd $PACKAGE-$VERSION; cp -r $FOLDER $LIB_TARGET)
}

echo "Creating installer for version" $(cat latest-version)

OP2=$(pwd)/distrib/
LIB_TARGET=${OP2}/openproximity2/libs
CWD=$(pwd)

rm -rf $OP2
mkdir -p $OP2/openproximity2
mkdir -p $LIB_TARGET

cd $OP2/openproximity2
ln -s $CWD/client.sh
ln -s $CWD/common.sh
ln -s $CWD/django-web
ln -s $CWD/latest-version
ln -s $CWD/LICENSE
ln -s $CWD/manager.sh
#ln -s $CWD/op_lib/rosetta $LIB_TARGET/rosetta
#ln -s $CWD/op_lib/django_cpserver $LIB_TARGET/django_cpserver
ln -s $CWD/op_lib/net $LIB_TARGET/net
ln -s $CWD/op_lib/plugins $LIB_TARGET/plugins
ln -s $CWD/pair.py
ln -s $CWD/pair.sh
ln -s $CWD/remoteScanner
ln -s $CWD/remote_scanner.sh
ln -s $CWD/rpc_scanner.sh
ln -s $CWD/rpc.sh
ln -s $CWD/rpc_uploader.sh
ln -s $CWD/run.sh
ln -s $CWD/server.sh
ln -s $CWD/serverXR
ln -s $CWD/shell.sh
ln -s $CWD/syncdb.sh
ln -s $CWD/syncagent.sh


cd $OP2
mkdir tmp
cd tmp

download_and_uncompress rpyc 3.0.6 rpyc http://ufpr.dl.sourceforge.net/sourceforge/rpyc
download_and_uncompress Django 1.1 django http://media.djangoproject.com/releases/1.1
download_and_uncompress lincolnloop-django-cpserver 19739be django_cpserver http://github.com/lincolnloop/django-cpserver/tarball
download_and_uncompress django-rosetta 0.4.7 rosetta http://django-rosetta.googlecode.com/files
download_and_uncompress wadofstuff-django-serializers 1.0.0 wadofstuff http://wadofstuff.googlecode.com/files
download_and_uncompress poster 0.4 poster http://pypi.python.org/packages/source/p/poster/
#download_and_uncompress pytz 2009n pytz http://pypi.python.org/packages/source/p/pytz/
cd $OP2

for i in $(ls $CWD/patches/*.patch); do
    (cd openproximity2/libs; patch -p0 < $i)
done

rm -rf tmp
(cd openproximity2; bash manager.sh compilemessages)
rm -f $(find . | grep "\.pyc$")
rm -f $(find . | grep "\.pyo$")
tar --numeric-owner -h --group=0 --exclude=\*svn --owner=0 -czf $CWD/openproximity2-$(cat $CWD/latest-version).tar.gz openproximity2