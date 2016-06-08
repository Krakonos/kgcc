#!/bin/sh

function die() {
	echo "$@" >&2
	exit 1;

}

BRANCH=`git describe --tags | sed -e 's/ \t//g;s/-[0-9]\+-g.*//'`
BDIR="build-$BRANCH"

echo "Using build directory '$BDIR'"

rm -rf "$BDIR"
mkdir "$BDIR"
cd "$BDIR"

export CFLAGS="-fno-omit-frame-pointer -g"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="$CFLAGS"
../configure --prefix=$HOME/kgcc/$BRANCH --enable-gather-detailed-mem-stats --enable-languages=c++,c || die "configure failed"
time make -j8 || die "make failed"
