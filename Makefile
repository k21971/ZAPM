# to build a multi-user version, make clean and then make zapm-multiuser
#

OBJS = Global.o Armor.o Artifact.o Attack.o BunkerRooms.o Canister.o	\
Cave.o Corpse.o Creature.o Doctor.o Droid.o Energy.o Event.o Fight.o	\
FloppyDisk.o Game.o God.o Help.o Hero.o Implant.o Interface.o		\
Inventory.o Mainframe.o Map.o Money.o Monster.o MonsterAI.o Mutant.o	\
Object.o ObjectParser.o Options.o Path.o Profession.o RabbitLevel.o	\
RayGun.o Render.o Room.o SaveLoad.o Sewer.o SewerPlant.o Shop.o		\
Skills.o Tombstone.o Tool.o Town.o TwistyRooms.o Util.o Vat.o Vision.o	\
Weapon.o main.o

ZAPMOWNER= games:games
CHROOT= /opt/nethack/chroot
GAMEDIR= $(CHROOT)/zapm
#GAMEDIR= "/opt/devnull/nethackdir"
#DATADIR= "/opt/devnull/nethackdir/zapmdir"
DATADIR= "/zapm/var"
CHALLENGE= "/dgldir/devnull/challenge"
INPR=/dgldir/inprogress-zapm

#ARCH = -arch i386 -arch ppc

LIBS= -lpanel -lncurses
INCLUDE=
#LDFLAGS= $(ARCH)
LDFLAGS=
CXX = g++
#CXX= c++-4.0


CXXFLAGS=-Wall -Wextra -fpermissive -Wno-char-subscripts -O0 -g3 -std=c++98 $(INCLUDE) $(ARCH)

all: zapm-tournament

install: all
	mkdir -p $(GAMEDIR)
	cp zapm $(GAMEDIR)
	mkdir -p $(CHROOT)$(DATADIR)
	mkdir -p $(CHROOT)$(INPR)
	-chown $(ZAPMOWNER) $(CHROOT)$(DATADIR)
	-chown $(ZAPMOWNER) $(CHROOT)$(INPR)
	-chown $(ZAPMOWNER) $(GAMEDIR)/zapm
	chmod 00755 $(GAMEDIR)/zapm
	chmod 00755 $(CHROOT)$(DATADIR)
	chmod 00755 $(CHROOT)$(INPR)

zdebug: oneuser zapm
	mkdir -p build
	mkdir -p build/zapm
	mkdir -p build/zapm/user
	cp zapm build/zapm/

zapm-oneuser: oneuser zapm
	mkdir -p build
	mkdir -p build/zapm
	mkdir -p build/zapm/user
	cp zapm build/zapm/
	strip build/zapm/zapm
	cp docs/Guide.txt build/zapm
	tar czf zapm.tar.gz -C build zapm

zapm-multiuser: multiuser zapm

zapm-tournament: tournament zapm

zapm-win32: win32/Release/zapm.exe
	mkdir -p win32/build/zapm/user
	cp win32/Release/zapm.exe win32/build/zapm/
	cp docs/Guide.txt win32/build/zapm
	rm -f zapm.zip
	cd win32/build && zip -r ../zapm.zip zapm

zapm: $(OBJS)
	g++ -g -o zapm $(LDPATH) $(LDFLAGS) $(OBJS) $(LIBS)

debug: $(OBJS)
	g++ -g -o zapm $(LDPATH) $(LDFLAGS) $(OBJS) $(LIBS) $(DEBUGLIBS)

clean:
	rm -f zapm *.o config.h dbg.txt gmon.out

cleaner: clean
	rm -f *~ \#*\#

Monster.o : MonsterData.h

tournament : multiuser
	echo '#define CHALLENGE $(CHALLENGE)' >> config.h

multiuser :
	echo "/* this file is automatically generated!! */ " > config.h
	echo '#define DATADIR $(DATADIR)' >> config.h

oneuser :
	echo "/* this file is automatically generated!! */ " > config.h
	echo '#define DATADIR "user"' >> config.h

MonsterData.h : monsters.dat monsters.pl
	./monsters.pl > MonsterData.h
