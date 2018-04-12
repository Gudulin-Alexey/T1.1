programm := hello
dinamic = libgoodbye.c# переменная хранящая имена исходников которые нужно скомпилировать как для динамической библиотеки
source_files = $(wildcard *.c) # все исходные файлы в текущей директории
obj_files = $(patsubst %.c,%.o,$(filter-out $(dinamic),$(source_files))) # .o файлы которые будут скомпилированы без флага -fPIC
dinamic_obj = $(patsubst %.c,%.o,$(dinamic))# .o файлы с флагом -fPIC
dinamic_libs =
static_libs = $(patsubst %.c,%.a,$(filter-out $(dinamic),$(filter lib%.c,$(source_files)))) # считаем что имена файлов нач. с lib статич. библиотеки	
dinamic_libs = $(patsubst %.o,%.so,$(dinamic_obj)) 
ifneq ($(strip $(dinamic)),)
DFLAGS=-Wl,-rpath,. # флаг чтобы при компановке программа знала откуда брать динам. библиотеки
endif
.PHONY: clean libs
all: $(programm)

$(programm): $(obj_files) $(static_libs) $(dinamic_libs)
	gcc -o $@ $(filter-out lib%.o,$(obj_files)) -L. $(patsubst lib%.a,-l%,$(static_libs)) $(patsubst lib%.so,-l%,$(dinamic_libs)) $(DFLAGS)

$(obj_files): %.o : %.c
	gcc -c $<

$(dinamic_obj): %.o : %.c
	gcc -c -fPIC $<

$(static_libs): %.a: %.o
	ar cr $@ $<

$(dinamic_libs): %.so: %.o
	gcc -shared -o $@ $<
libs: $(static_libs) $(dinamic_libs)

clean:
	rm -rf hello *.o *.a *.so

