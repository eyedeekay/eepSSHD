
i2pd_dat?=$(PWD)/i2pd_dat

docker-build: pull
	docker build --force-rm -f Dockerfile -t eyedeekay/eepsshd .

pull:
	git pull

docker-run:
	docker run \
		-d \
		--name sshd-host \
		--hostname sshd-host \
		--restart always \
		-p :4567 \
		-p 127.0.0.1:7070:7070 \
		--volume $(i2pd_dat):/var/lib/i2pd:rw \
		-t eyedeekay/eepsshd; true

run: docker-build docker-run
