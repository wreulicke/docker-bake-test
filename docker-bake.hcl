variable "VERSION" {
  default = "$VERSION"
}

target "docker-metadata-action" {}

target "builder-base" {
  dockerfile = "Dockerfile.base"
  context = "./"
}

target "default" {
  matrix = {
    img = [
      "foo",
      "bar",
      "baz"
    ]
  }

  inherits = ["docker-metadata-action"]
  context = "./"
  # target分けて、groupでまとめる方が良さそう
  dockerfile = img == "baz" ? "Dockerfile.baz" : "Dockerfile"
  args = {
    VERSION = "${VERSION}"
  }
  contexts = {
    # Dockerfileのbuilder-baseをtarget:builder-baseにする
    builder-base = "target:builder-base"
  }
  name = img
  tags = [
    for tag in target.docker-metadata-action.tags: "default-${img}:${replace(tag, "dummy:", "")}"
  ] 
  target = img
}

