_DEBUG = $(if $(DEBUG),-D DEBUG,)
_OPT = $(if $(OPT),-O3 -flto,)
CC = gcc
CFLAGS = -g -std=c99 -Wall $(_OPT) -I./include $(_DEBUG)

.PHONY: clean clean-all clean-img doc check-syntax all compile-all naive naive-compile-all launch-tests video enlarge-image run-% valgrind-%
.DEFAULT_GOAL:= all


# Generate doxygen documentation
doc:
	doxygen ./doxygen/Doxyfile >/dev/null 2>&1
	rm -f doxygen_documentation.html
	ln -s docs/index.html doxygen_documentation.html


# Remove output files and executables
clean:
	rm -f *.o

# Remove documentation files
clean-doc:
	rm -rf docs
	rm -f doxygen_documentation.html

# Remove output images and videos
clean-img:
	rm -f out/*.pgm video.mp4

# Remove output files
clean-all:
	rm -f *.o doxygen_documentation.html video.mp4 out/*.pgm
	find . -executable -type f -delete
	rm -rf docs


# Generic compilation recipes
%.o: ./src/%.c
	$(CC) $(CFLAGS) -o $@ -c $^

%.o: ./tests/%.c
	$(CC) $(CFLAGS) -o $@ -c $^


# Syntax check (put all .o files as prerequisites here)
check-syntax: naive_universe.o test-naive-universe.o naive_loader.o test-naive-loader.o app-naive-loader.o naive_conway.o test-naive-conway.o app-naive-conway.o naive_ppm_writer.o test-naive-generate-image.o linked_list_cell.o list_universe.o test-list-universe.o list_loader.o test-list-loader.o app-list-loader.o list_conway.o test-list-conway.o list_conway_expandable.o list_optionsparser.o app-naive-conway.o

# Application building rules
test-naive-universe: test-naive-universe.o naive_universe.o
	$(CC) $(CFLAGS) -o $@ $^
test-naive-loader: test-naive-loader.o naive_universe.o naive_loader.o
	$(CC) $(CFLAGS) -o $@ $^
app-naive-loader: app-naive-loader.o naive_universe.o naive_loader.o
	$(CC) $(CFLAGS) -o $@ $^
test-naive-conway: test-naive-conway.o naive_universe.o naive_loader.o naive_conway.o naive_pbm_writer.o
	$(CC) $(CFLAGS) -o $@ $^
app-naive-conway: app-naive-conway.o naive_universe.o naive_loader.o naive_conway.o naive_optionsparser.o naive_pbm_writer.o
	$(CC) $(CFLAGS) -o $@ $^
test-naive-generate-image: test-naive-generate-image.o naive_universe.o naive_loader.o naive_pbm_writer.o
	$(CC) $(CFLAGS) -o $@ $^
test-list-universe: test-list-universe.o linked_list_cell.o list_universe.o
	$(CC) $(CFLAGS) -o $@ $^
test-list-loader: test-list-loader.o linked_list_cell.o list_universe.o list_loader.o
	$(CC) $(CFLAGS) -o $@ $^
app-list-loader: app-list-loader.o list_universe.o list_loader.o linked_list_cell.o
	$(CC) $(CFLAGS) -o $@ $^
test-list-conway: test-list-conway.o linked_list_cell.o list_universe.o list_loader.o list_conway.o
	$(CC) $(CFLAGS) -o $@ $^
app-list-conway: app-list-conway.o list_optionsparser.o list_conway.o list_conway_expandable.o list_loader.o list_universe.o linked_list_cell.o list_pbm_writer.o
	$(CC) $(CFLAGS) -o $@ $^
test-list-generate-image: test-list-generate-image.o linked_list_cell.o list_universe.o list_loader.o list_pbm_writer.o
	$(CC) $(CFLAGS) -o $@ $^

# Build and run
run-%:
	clear
	make $*
	./$* $(ARGS)

valgrind-%:
	clear
	make $*
	valgrind --leak-check=full --show-leak-kinds=all ./$* $(ARGS)


# USER RULES
all: doc app-naive-loader app-naive-conway app-list-loader app-list-conway clean

compile-all: doc test-naive-universe test-naive-loader app-naive-loader test-naive-conway app-naive-conway test-naive-generate-image test-list-universe test-list-loader app-list-loader test-list-conway app-list-conway

naive: app-naive-loader app-naive-conway clean

naive-compile-all: test-naive-universe test-naive-loader app-naive-loader test-naive-conway app-naive-conway test-naive-generate-image

linkedlist: app-list-loader app-list-conway clean

linkedlist-compile-all: test-list-universe test-list-loader app-list-loader test-list-conway app-list-conway


# TESTS
ALL_TESTS = test-naive-universe test-naive-loader test-naive-conway test-naive-generate-image test-list-universe test-list-loader test-list-conway

launch-tests: $(ALL_TESTS)
	for x in $(ALL_TESTS); do ./$$x --all; done


# VIDEO
WIDTH=1024
HEIGHT=768

enlarge-image: out
	mogrify -format png -background white -scale $(WIDTH)X$(HEIGHT) -filter box -extent $(WIDTH)X$(HEIGHT) -gravity center out/*.p*m

video: out enlarge-image
	ffmpeg -y -framerate 5 -i out/img-%03d.png -vcodec libx264 -vf format=yuv420p video.mp4
	rm -f out/*.png >/dev/null
