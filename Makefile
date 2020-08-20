.PHONY: all
all: build 

build: clean 
	mkdir tmp
	cp -fv pkg/hello-world opt/github.com/simon.services/hello-world/bin/hello-world
	rm -fv opt/github.com/simon.services/hello-world/bin/.empty
	chmod +x opt/github.com/simon.services/hello-world/bin/hello-world
	rsync -ax --exclude tmp ./ tmp/
	rm -rfv tmp/Makefile tmp/.git tmp/.gitignore tmp/LICENSE tmp/README.md tmp/cmd tmp/pkg
	dpkg-deb --build tmp hello-world-0.0.1-amd64.deb
	rm -rf tmp

.PHONY: clean 
clean:
	rm -fv *~ .*.swp *.deb
	rm -rf hello-world tmp
	rm -fv opt/github.com/simon.services/hello-world/bin/hello-world

