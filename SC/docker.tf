# Configure the Docker provider
provider "docker" {
  host = "tcp://10.49.165.112:2375/"
}

# Create a container
resource "docker_container" "Infra_manager" {
  name  = "${random_string.random_name.result}"
  image = "${docker_image.dummy_image.latest}"
  entrypoint = ["/bin/sleep"]
  command = [ "1d" ]
}

resource "docker_image" "dummy_image" {
	  name = "busybox:latest"
	}
	
resource "random_string" "random_name" {
		length  = 5
		special = false
		lower   = false
	} 
