provider "docker" 
{   host = "tcp://vviedksw01.sbb01.spoc.global:2375" 
    
}



resource "docker_container" "new-sample" {
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