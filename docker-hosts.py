import docker

NL = "\n"
HOSTS_FILE = "hosts"
DOCKER_HOSTS_START = "# Docker hosts start"+NL
DOCKER_HOSTS_END = "# Docker hosts end"+NL

client = docker.from_env()


def remove_lines():
    file = open(HOSTS_FILE, "r+")
    lines = file.readlines()
    file.seek(0)
    remove_line = False
    for line in lines:
        if line == DOCKER_HOSTS_START:
            remove_line = True

        if not remove_line:
            file.write(line)

        if line == DOCKER_HOSTS_END:
            remove_line = False

    file.truncate()
    file.close()
    return


def write_lines(lines):
    file = open(HOSTS_FILE, "a")
    file.write(DOCKER_HOSTS_START)
    file.writelines(lines)
    file.write(DOCKER_HOSTS_END)
    file.close()
    return


remove_lines()

for event in client.events(filters={'type': 'container'}):
    remove_lines()
    lines = []
    for container in client.containers.list():
        print("# {0}".format(container.name))
        for network in container.attrs['NetworkSettings']['Networks']:
            ip_addresses = "{1} {0}.docker".format(container.name, container.attrs['NetworkSettings']['Networks'][network]['IPAddress'])
            print(ip_addresses)
            lines.append(ip_addresses+NL)
    write_lines(lines)