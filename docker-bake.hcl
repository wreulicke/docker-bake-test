variable "VERSION" {
  default = "$VERSION"
}

target "docker-metadata-action" {}

target "default" {
  matrix = {
    img = [
      "foo",
      "bar",
    ]
  }

  inherits = ["docker-metadata-action"]
  context = "./"
  dockerfile = "Dockerfile"
  args = {
    VERSION = "${VERSION}"
  }
  name = img
  tags = [
    "default-${img}:${VERSION}",
  ] 
  target = img
}

