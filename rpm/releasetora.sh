#!/bin/sh

LD_LIBRARY_PATH=/usr/local/kde/lib
export LD_LIBRARY_PATH

if [ "X$1" = "X" ]
then
    echo Missing version
    exit 1
fi

rm -rf t
mkdir -p t
cd t
if [ "X$2" = "X" ]
then
    echo Releasing head
    cvs -z3 -d:pserver:anonymous@cvs.tora.sourceforge.net:/cvsroot/tora co tora
else
    echo Releasing branch $2
    cvs -z3 -d:pserver:anonymous@cvs.tora.sourceforge.net:/cvsroot/tora co -r$2 tora
fi
rm -rf `find tora -name CVS`
touch tora/* tora/*/*
mv tora tora-$1
tar czf ../tora-$1.tar.gz tora-$1
tar cf - tora-$1 | bzip2 > /usr/src/RPM/SOURCES/tora-$1.tar.bz2
rpm -bb tora-$1/rpm/tora.spec
rpm -bb tora-$1/rpm/tora-mdk.spec

SRCPWD=`pwd`
cd /usr/src/RPM/BUILD/tora-$1
make tora-mono
strip tora-mono
mv tora-mono tora
cd ..
echo Packing tora-$1-bin.tar.gz
tar czf $SRCPWD/../tora-$1-bin.tar.gz tora-$1/tora tora-$1/README tora-$1/LICENSE \
    tora-$1/BUGS tora-$1/NEWS tora-$1/INSTALL tora-$1/TODO tora-$1/templates/sqlfunctions.tpl \
    tora-$1/icons/tora.xpm tora-$1/icons/toramini.xpm tora-$1/help

cd $SRCPWD
rpm -bb tora-$1/rpm/tora-static.spec
cd /usr/src/RPM/BUILD/tora-$1
strip tora-static
mv tora-static tora
cd ..
echo Packing tora-$1-static.tar.gz
tar czf $SRCPWD/../tora-$1-static.tar.gz tora-$1/tora tora-$1/README tora-$1/LICENSE \
    tora-$1/BUGS tora-$1/NEWS tora-$1/INSTALL tora-$1/TODO tora-$1/templates/sqlfunctions.tpl \
    tora-$1/icons/tora.xpm tora-$1/icons/toramini.xpm tora-$1/help

cd $SRCPWD
rpm -bb tora-$1/rpm/tora-qt.spec
cd /usr/src/RPM/BUILD/tora-$1
make tora-mono
strip tora-mono
mv tora-mono tora
cd ..
echo Packing tora-$1-qt.tar.gz
tar czf $SRCPWD/../tora-$1-qt.tar.gz tora-$1/tora tora-$1/README tora-$1/LICENSE \
    tora-$1/BUGS tora-$1/NEWS tora-$1/INSTALL tora-$1/TODO tora-$1/templates/sqlfunctions.tpl \
    tora-$1/icons/tora.xpm tora-$1/icons/toramini.xpm tora-$1/help

cd $SRCPWD/..
rm -rf t
cp /usr/src/RPM/RPMS/i686/tora-$1-* .
#rm -rf /usr/src/RPM/BUILD/*
