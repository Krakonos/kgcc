#!/bin/sh

function die() {
	echo "$@" >&2
	exit 1;

}

function usage() {
cat >&2 <<EOF
Usage: $0 [-r] [-i]
	-r        do a full rebuild, removing the BDIR first
	-i        install when done
EOF
#	-d DIR    set BDIR to DIR, instead of the default name derived from current git branch
}

DO_REBUILD=0
DO_INSTALL=0
PRETEND=0

while getopts ":rip" opt; do
  case $opt in
    r)
	    DO_REBUILD=1
      ;;
	i)
		DO_INSTALL=1
	  ;;
	p)
		PRETEND=1
	  ;;
    *)
	  usage
	  exit 1
      ;;
  esac
done

BRANCH=`git describe --tags | sed -e 's/ \t//g;s/-[0-9]\+-g.*//'`
BDIR="build-$BRANCH"

echo "Using build directory '$BDIR'"

if [ $PRETEND -eq 1 ]; then
	echo "Just joking!"
	exit 0
fi

export CFLAGS="-fno-omit-frame-pointer -g"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="$CFLAGS"
export CXX="ccache g++"
export CC="ccache gcc"

if [ $DO_REBUILD -eq 1 ]; then
	echo "Doing full rebuild. The directory '$BDIR' will be removed in 5 seconds...."
	sleep 5
	rm -rf "$BDIR"
fi

if [ ! -d "$BDIR" ]; then
	mkdir "$BDIR"
	cd "$BDIR"
	../configure --prefix=$HOME/kgcc/$BRANCH --enable-languages=c++,c --disable-bootstrap || die "configure failed"
else
	echo "Build directory already exists, skipping configure phase. Pass '-r' to do a full rebuild."
	cd "$BDIR"
fi

time make -j8 || die "make failed"

if [ $DO_INSTALL -eq 1 ]; then
	make install || die "make install failed"
fi
