LINKER_SCRIPT = ../../linker_script

all:	test.rom sc_screen.rom title_screen.rom game_over_screen.rom

###

test.rom:	test.o
	ld65 -o test.rom test.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

test.o:	test.s test_graphic.inc test_overlay.inc
	ca65 -o test.o test.s -l test.lst

###

sc_screen.rom:	sc_screen.o
	ld65 -o sc_screen.rom sc_screen.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

sc_screen.o:	sc_screen.s sc_graphic.inc sc_overlay.inc
	ca65 -o sc_screen.o sc_screen.s -l sc_screen.lst

###

title_screen.rom:	title_screen.o
	ld65 -o title_screen.rom title_screen.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

title_screen.o:	title_screen.s title_graphic.inc title_data.inc
	ca65 -o title_screen.o title_screen.s -l title_screen.lst

###

game_over_screen.rom:	game_over_screen.o
	ld65 -o game_over_screen.rom game_over_screen.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

game_over_screen.o:	game_over_screen.s game_over.inc game_overlay.inc
	ca65 -o game_over_screen.o game_over_screen.s -l game_over_screen.lst



###

clean:	
	rm -f *~ *.o *.lst test.rom sc_screen.rom title_screen.rom game_over_screen.rom


