.PHONY: all
all: build 

hello-world:
	go build -o hello-world cmd/hello-world/main.go

build: clean hello-world
	mkdir tmp
	mv hello-world opt/github.com/simon.services/hello-world/bin/hello-world
	rm -fv opt/github.com/simon.services/hello-world/bin/.empty
	chmod +x opt/github.com/simon.services/hello-world/bin/hello-world
	rsync -ax --exclude tmp ./ tmp/
	rm -rfv tmp/Makefile tmp/.git tmp/.gitignore tmp/LICENSE tmp/README.md
	dpkg-deb --build tmp hello-world-0.0.1-amd64.deb
	rm -rf tmp

lxd-test: build
	lxc delete -f test-hello-world
	lxc launch "images:debian/11" test-hello-world
	lxc file push hello-world-0.0.1-amd64.deb test-hello-world/root/
	lxc exec test-hello-world -- bash -c "apt update && apt upgrade -y && apt install -y -f ./hello-world-0.0.1-amd64.deb"

.PHONY: clean 
clean:
	rm -fv *~ .*.swp *.deb
	rm -rf hello-world tmp
	rm -fv opt/github.com/simon.services/hello-world/bin/hello-world

