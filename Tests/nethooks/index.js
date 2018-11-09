const express = require('express')
const { execSync } = require('child_process')
const app = express()
const anchor = (process.env.PF_ANCHOR != null) ? process.env.PF_ANCHOR : "com.apple"
const port = (process.env.PORT != null) ? parseInt(process.env.PORT, 10): 7034

app.get('/', (req, res) => {
  res.set('Content-Type', 'text/plain')
  res.send("OK")
})

app.get('/status', (req, res) => {
  res.set('Content-Type', 'text/plain')
  res.send(execSync(`pfctl -a "${ anchor }" -s all`))
})

app.get('/enable', (req, res) => {
  let out = execSync('pfctl -e')
  res.set('Content-Type', 'text/plain')
  res.send(out)
})

app.get('/disable', (req, res) => {
  let out = execSync('pfctl -d')
  res.set('Content-Type', 'text/plain')
  res.send(out)
})

app.get('/block-reset/:dir/:port', (req, res) => {
  let { port, dir } = req.params 
  let out = execSync(`echo "block return-rst ${ dir } proto tcp from any to any port ${ port }" | pfctl -a "${ anchor }" -f - `)
  res.set('Content-Type', 'text/plain')
  res.send(out)
})

app.get('/revert', (req, res) => {
  let out = execSync(`pfctl -a "${ anchor }" -F all -f /etc/pf.conf`)
  res.set('Content-Type', 'text/plain')
  res.send(out)
})

app.listen(port, () =>
  console.log(`Nethooks listening on port ${port}`)
)
