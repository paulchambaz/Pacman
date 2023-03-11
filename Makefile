run:
	@processing-java --sketch=Pacman --run

build:
	@processing-java --sketch=Pacman --output=build --export

install: build
	@mkdir -p /usr/share/Pacman
	@cp -r build/* /usr/share/Pacman
	@chmod 755 /usr/share/Pacman -R
	@printf "#!/bin/bash\ncd /usr/share/Pacman && ./Pacman\n" > /usr/bin/Pacman
	@chmod 755 /usr/bin/Pacman

uninstall:
	@rm -fr /usr/share/Pacman
	@rm /usr/bin/Pacman

clean:
	@rm -fr build
