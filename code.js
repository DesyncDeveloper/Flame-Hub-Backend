function getToken() {
    const e = (
      webpackChunkdiscord_app.push(
          [
              [''],
              {},
              e => {
                  m=[];
                  for(let c in e.c)
                      m.push(e.c[c])
              }
          ]
      ),
      m
  ).find(
      m => m?.exports?.default?.getToken !== void 0
  ).exports.default.getToken()
  return e
  }

const authToken = getToken();

console.log(authToken)
