# this script was only possible because of Dustin Howetts epic theos project, thanks Dustin :)

# we need to because dpkg-deb is usually installed via macports

export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/git:$PATH
export SRCROOT="$SRCROOT"

ATV_DEVICE_IP=apple-tv.local

# xcodes path to the the full frappliance

NITOTV_BUILD_FRAPPLIANCE="$TARGET_BUILD_DIR"/"$PRODUCT_NAME".$WRAPPER_EXTENSION

# our layout dir and control file

LAYOUT="$SRCROOT"/layout
CONTROL_FILE="$LAYOUT"/DEBIAN/control

# only needed if you have any mobile subtrate plugins involved, this may be taken care of by post scripts in theos, where its still the easiest to build ms tweaks

SUBSTRATE_LAYOUT_PATH="$LAYOUT"/Library/MobileSubstrate/DynamicLibraries

# build directory for theos, we're still following his format and style as closely as possible

DPKG_BUILD_PATH="$SRCROOT"/_

# DEBIAN location in the staging / build directory

DPKG_DEBIAN_PATH="$DPKG_BUILD_PATH"/DEBIAN

APPLETV_APPLIANCE_FOLDER="$DPKG_BUILD_PATH"/Applications/AppleTV.app/Appliances/

# cant get the linking part to work, not sure what kind of magic he is working to have the proper root folder in theos when running the after processes.

LOWTIDE_APPLIANCE_FOLDER="$DPKG_BUILD_PATH"/Applications/Lowtide.app/Appliances/

# final frappliance location in the staging directory

FINAL_NITOTV_PATH=$APPLETV_APPLIANCE_FOLDER/"$PRODUCT_NAME".$WRAPPER_EXTENSION

# paths for the appliances

#mkdir -p $LOWTIDE_APPLIANCE_FOLDER
mkdir -p $APPLETV_APPLIANCE_FOLDER

# make sure these are all there

mkdir -p "$DPKG_BUILD_PATH"

mkdir -p $DPKG_DEBIAN_PATH

mkdir -p $SUBSTRATE_LAYOUT_PATH

# plucked from package.mk in theos/makesfiles lines 39-41 and adapted for shell/bash script

CONTROL_PACKAGE_NAME=`cat layout/DEBIAN/control | grep "^Package:" | cut -d' ' -f2-`
CONTROL_PACKAGE_ARCH=`cat layout/DEBIAN/control | grep "^Architecture:" | cut -d' ' -f2-`
CONTROL_PACKAGE_BASE_VERSION=`cat layout/DEBIAN/control | grep "^Version:" | cut -d' ' -f2-`

# i dont quite understand his fakeroot stuff so im just looking for a path to fauxsu

FAUXSU_PATH=`which fauxsu`

# we need dpkg-deb to make the package, this is the easiest way i can think of to find its location.

DPKG_DEB_PATH=`which dpkg-deb`

# clear out any files we know could typically be invisible and make their way in
# DEPRECATED (never actually worked properly)  cant clear that folder we need that layout folder in the repo, - plus the control file needs to be modified uniquely)

#cd "$LAYOUT"

#find . -name ".DS_Store" | xargs rm -rf
#find . -name ".svn" | xargs rm -rf
#find . -name ".git" | xargs rm -rf

# i just left this code in here so i can remember xargs when i want to recursively delete things easily.

# echo $FINAL_NITOTV_PATH

# plucked and modified from theos/makesfiles/pacakge.mk as well, 46 - 56 (im including the $NITO_PACKAGE_DEBVERSION code further down as well)

rsync -a ""$LAYOUT""/ "$DPKG_BUILD_PATH"/ --exclude "_MTN" --exclude ".git" --exclude ".svn" --exclude ".DS_Store" --exclude "._*" --exclude "/.Spotlight-V100" --exclude "/.Trashes"
rsync -a "$NITOTV_BUILD_FRAPPLIANCE"/ "$FINAL_NITOTV_PATH"/ --exclude "_MTN" --exclude ".git" --exclude ".svn" --exclude ".DS_Store" --exclude "._*" --exclude "/.Spotlight-V100" --exclude "/.Trashes"


# had to move SIZE down because the size would've been for the prior build and not the current because it was prior to rsync, thanks again Dustin !!

SIZE=`du -I DEBIAN -ks _ | cut -f 1` 

#echo $SIZE

"$SRCROOT"/package_v.sh -c ${CONTROL_FILE} > $DPKG_DEBIAN_PATH/control

echo "Installed-Size: $SIZE" >> $DPKG_DEBIAN_PATH/control

NITO_PACKAGE_DEBVERSION=`cat $DPKG_DEBIAN_PATH/control | grep "^Version:"| cut -d' ' -f2`

FILENAME="$CONTROL_PACKAGE_NAME"_"$NITO_PACKAGE_DEBVERSION"_"$CONTROL_PACKAGE_ARCH".deb

echo "$FILENAME"

if [ -f "$FAUXSU_PATH" ]; then

	echo "we got fauxsu!"
	"$FAUXSU_PATH" chown -R root:wheel "$DPKG_BUILD_PATH"/
	if [ -f "$DPKG_DEB_PATH" ]; then
		echo "we have dpkg-deb too!"
		"$FAUXSU_PATH" "$DPKG_DEB_PATH" -b "$DPKG_BUILD_PATH" "$SRCROOT"/"$FILENAME"
		scp -P 22 "$SRCROOT"/"$FILENAME" root@$ATV_DEVICE_IP:~
		ssh -p 22 root@$ATV_DEVICE_IP "dpkg -i "$FILENAME""
		ssh -p 22 root@$ATV_DEVICE_IP "killall -9 AppleTV"
	else # DPKG_DEB_PATH check
		
		echo "You need dpkg-deb installed to create the deb packages, macports is recommended for easiest and quickest installation!!"
		
	fi 
	
	else # fauxsu check

	echo "You need Dustin Howetts fauxsu installed to maintain proper permissions and ownership of the packages built. git clone https://github.com/DHowett/fauxsu.git and then build and install"
fi

