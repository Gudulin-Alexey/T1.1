hello.o: hello.c
	gcc-c main.c
libhello.0: libhello.c
	gcc -c helloworld.c
libgoodbye.0: libgoodbye.c
	gcc -c libgoodbye.c
