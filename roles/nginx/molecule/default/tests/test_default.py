def test_nginx_is_installed(host):
    nginx = host.package("nginx-full")
    assert nginx.is_installed
    assert nginx.version.startswith("1.1")


def test_nginx_running_and_enabled(host):
    nginx = host.service("nginx")
    assert nginx.is_running
    assert nginx.is_enabled
