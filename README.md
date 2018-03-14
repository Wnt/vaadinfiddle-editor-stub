# 1. Run editor node
`docker run --volume /home/jonni/tmp:/fiddleapp --name editor-test  --interactive --tty vaadinfiddle/editor-stub mvn jetty:run -Dfiddle.directory=/fiddleapp`
# 2. Run runner node
`docker run --volumes-from editor-test --name runner-test --interactive --tty vaadinfiddle/runner-stub`
# 3. Set up nginx
```
location /editor/PUSH {
  proxy_pass http://172.17.0.2:8080/PUSH;
  proxy_http_version 1.1;
  proxy_set_header Upgrade $http_upgrade;
  proxy_set_header Connection "upgrade";
  proxy_read_timeout 15m;
}
location /editor/ {
  proxy_pass http://172.17.0.2:8080/;
  proxy_redirect default;
  proxy_cookie_path / /editor/;
  proxy_read_timeout 15m;
}
location /container/1/PUSH {
  proxy_pass http://172.17.0.3:8080/PUSH;
  proxy_http_version 1.1;
  proxy_set_header Upgrade $http_upgrade;
  proxy_set_header Connection "upgrade";
  proxy_read_timeout 15m;
}
location /container/1/ {
  proxy_pass http://172.17.0.3:8080/;
  proxy_redirect default;
  proxy_cookie_path / /container/1/;
  proxy_read_timeout 15m;
  add_header X-Frame-Options SAMEORIGIN;
}
```
# 4. After edits restart runner node
`docker restart runner-test`
