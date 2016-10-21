const {classes: Cc, interfaces: Ci, utils: Cu} = Components

const mpv_path = '/usr/bin/mpv'
const mpv_options = '--cache-file=TMP --loop-file --ytdl-raw-options=format=best'

let map = (shortcuts, command, custom=false) => {
  vimfx.set(`${custom ? 'custom.' : ''}mode.normal.${command}`, shortcuts)
}

let {Preferences} = Cu.import('resource://gre/modules/Preferences.jsm', {})

vimfx.addCommand({
  name: 'play_with_mpv',
  description: 'Play focused element, hovered link, or current tab with mpv'
}, ({vim}) => {
  vimfx.send(vim, 'getCurrentHref', null, url => {
    let file = Cc['@mozilla.org/file/local;1'].createInstance(Ci.nsIFile)
    file.initWithPath(mpv_path)

    let process = Cc['@mozilla.org/process/util;1'].createInstance(Ci.nsIProcess)
    process.init(file)

    if (!url) {
      var url = vim.window.gBrowser.selectedBrowser.currentURI.spec
    }

    let args = mpv_options.split(' ')

    if (url.includes('youtube.com')) {
      // Parse url params to an object like:
      // {"v":"g04s2u30NfQ","index":"3","list":"PL58H4uS5fMRzmMC_SfMelnCoHgB8COa5r"}
      let qs = (function(a) {
        if (a == '') return {}
        let b = {}
        for (let i = 0; i < a.length; ++i) {
          let p = a[i].split('=', 2)
          if (p.length == 1) {
            b[p[0]] = ''
          } else {
            b[p[0]] = decodeURIComponent(p[1].replace(/\+/g, ' '))
          }
        }
        return b
      })(url.substr(1).split('&'))

      if (qs['list'] && qs['index']) {
        // Example args: ['--video-unscaled=yes', '--ytdl-raw-options=format=best']
        // So check for ytdl-raw-options.
        let ytdlRawOptionsIndex = -1
        for (let i = 0; i < args.length; i++) {
          if (args[i].includes('ytdl-raw-options')) {
            ytdlRawOptionsIndex = i
            break
          }
        }

        if (ytdlRawOptionsIndex > -1) {
            args[ytdlRawOptionsIndex] += `,yes-playlist=,playlist-start=${qs['index']}`
        } else {
            args.push(`--ytdl-raw-options=yes-playlist=,playlist-start=${qs['index']}`)
        }
      }
    }

    args.push(url)

    process.runAsync(args, args.length)
  })
})
map('gv', 'play_with_mpv', true)

vimfx.addCommand({
  name: 'dark',
  description: 'Adjust for low (dark) ambient light'
}, ({vim}) => {
  Preferences.set({
    'devtools.theme': 'dark',
    'extensions.stylish.styleRegistrationEnabled': true,
    'layout.css.devPixelsPerPx': '1.5',
  })
})
map(',d', 'dark', true)

vimfx.addCommand({
  name: 'light',
  description: 'Adjust for high ambient light'
}, ({vim}) => {
  Preferences.set({
    'devtools.theme': 'light',
    'extensions.stylish.styleRegistrationEnabled': false,
    'layout.css.devPixelsPerPx': '1.2',
  })
})
map(',l', 'light', true)

Preferences.set({
  'browser.download.useDownloadDir': false,
  'browser.safebrowsing.enabled': false,
  'browser.safebrowsing.malware.enabled': false,
  'browser.search.defaultenginename.US': 'DuckDuckGo',
  'browser.search.suggest.enabled': false,
  'browser.startup.homepage': 'about:blank',
  'browser.startup.page': 3,
  'browser.tabs.warnOnOpen': false,
  'browser.tabs.warnOnClose': false,
  'extensions.newtaboverride@agenedia.com.type': 'about:blank',
  'general.autoScroll': true,
  'media.peerconnection.ice.default_address_only': true,
  'network.cookie.cookieBehavior': 2,
  'network.cookie.prefsMigrated': true,
  'privacy.donottrackheader.value': 1,
  'privacy.trackingprotection.pbmode.enabled': false,
  'security.ssl.require_safe_negotiation': true,
  'signon.rememberSignons': false,
})
