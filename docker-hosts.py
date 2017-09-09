import docker

client = docker.from_env()

for event in client.events(filters={'type': 'container'}):
    print("####")
    for container in client.containers.list():
        print("# {0}".format(container.name))
        for network in container.attrs['NetworkSettings']['Networks']:
            ip_addresses = "{1} {0}.docker".format(container.name, container.attrs['NetworkSettings']['Networks'][network]['IPAddress'])
            print(ip_addresses)