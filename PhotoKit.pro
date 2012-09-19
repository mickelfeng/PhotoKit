#-------------------------------------------------
#
# Project created by QtCreator 2012-06-23T21:41:01
#
#-------------------------------------------------

TEMPLATE = subdirs
#CONFIG += ordered
SUBDIRS += libezlog libprogramoptions libNextEffect photokit test

libezlog.file = src/ezlog/src/libezlog.pro
libprogramoptions.file = src/ProgramOptions/src/libProgramOptions.pro
libNextEffect.file = src/NextEffect/src/libNextEffect.pro
photokit.file = src/PhotoKit.pro

win32 {
SUBDIRS += libexif
libexif.file = src/libexif-port/libexif.pro
photokit.depends += libexif
}
photokit.depends += libezlog libprogramoptions libNextEffect

symbian {
    TARGET.UID3 = 0xea6f847b
    # TARGET.CAPABILITY += 
    TARGET.EPOCSTACKSIZE = 0x14000
    TARGET.EPOCHEAPSIZE = 0x020000 0x800000
}


OTHER_FILES += README.md TODO \
	qtc_packaging/common/README \
	qtc_packaging/common/copyright \
	qtc_packaging/common/changelog \
	qtc_packaging/debian_harmattan/manifest.aegis \
	qtc_packaging/debian_harmattan/control \
	qtc_packaging/debian_harmattan/compat \
	qtc_packaging/debian_harmattan/PhotoKit.desktop \
	qtc_packaging/debian_fremantle/control \
	qtc_packaging/debian_fremantle/rules \
	qtc_packaging/debian_fremantle/compat \
	qtc_packaging/debian_i386/control \
	qtc_packaging/debian_i386/PhotoKit.desktop

# Add files and directories to ship with the application
# by adapting the examples below.
# file1.source = myfile
# dir1.source = mydir
#lang.files = i18n
#DEPLOYMENTFOLDERS = lang# file1 dir1
#include(deployment.pri)
#qtcAddDeployment()

# add a make command
defineReplace(mcmd) {
	return($$escape_expand(\n\t)$$1)
}

!isEmpty(MEEGO_VERSION_MAJOR): PLATFORM = harmattan
else:maemo5: PLATFORM = fremantle
else: PLATFORM = i386

NAME = $$basename(_PRO_FILE_PWD_)

fakeroot.target = fakeroot
fakeroot.depends = FORCE
fakeroot.commands = rm -rf fakeroot && mkdir -p fakeroot/usr/share/doc/$$NAME && mkdir -p fakeroot/DEBIAN
fakeroot.commands += $$mcmd(chmod -R 755 fakeroot)  ##control dir must be 755

deb.target = deb
deb.depends += fakeroot
deb.commands += $$mcmd(make install INSTALL_ROOT=\$\$PWD/fakeroot)
deb.commands += $$mcmd(cd fakeroot; md5sum `find usr -type f |grep -v DEBIAN` > DEBIAN/$$debmd5.target; cd -)
deb.commands += $$mcmd(cp $$PWD/qtc_packaging/debian_$${PLATFORM}/control fakeroot/DEBIAN)
deb.commands += $$mcmd(cp $$PWD/qtc_packaging/common/* fakeroot/usr/share/doc/$$NAME)
deb.commands += $$mcmd(gzip -9 fakeroot/usr/share/doc/$$NAME/changelog)
deb.commands += $$mcmd(dpkg -b fakeroot $${NAME}_0.3.7_$${PLATFORM}.deb)


QMAKE_EXTRA_TARGETS += fakeroot deb

