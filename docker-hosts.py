import docker

client = docker.from_env()

for event in client.events(filters={'type': 'container'}):
    print(event)
    for container in client.containers.list():
        #print(container)
        host_ip = "{0}\t{1}".format(container.name, container.attrs['NetworkSettings']['IPAddress'])
        print(host_ip)