/*
 * jQuery Browser Plugin v0.0.5
 * https://github.com/gabceb/jquery-browser-plugin
 *
 * Original jquery-browser code Copyright 2005, 2013 jQuery Foundation, Inc. and other contributors
 * http://jquery.org/license
 *
 * Modifications Copyright 2013 Gabriel Cebrian
 * https://github.com/gabceb
 *
 * Released under the MIT license
 *
 * Date: 2013-07-29T17:23:27-07:00
 */
(function(e,d,g){var a,c;e.uaMatch=function(j){j=j.toLowerCase();var i=/(opr)[\/]([\w.]+)/.exec(j)||/(chrome)[ \/]([\w.]+)/.exec(j)||/(version)[ \/]([\w.]+).*(safari)[ \/]([\w.]+)/.exec(j)||/(webkit)[ \/]([\w.]+)/.exec(j)||/(opera)(?:.*version|)[ \/]([\w.]+)/.exec(j)||/(msie) ([\w.]+)/.exec(j)||j.indexOf("trident")>=0&&/(rv)(?::| )([\w.]+)/.exec(j)||j.indexOf("compatible")<0&&/(mozilla)(?:.*? rv:([\w.]+)|)/.exec(j)||[];var h=/(ipad)/.exec(j)||/(iphone)/.exec(j)||/(android)/.exec(j)||/(windows phone)/.exec(j)||/(win)/.exec(j)||/(mac)/.exec(j)||/(linux)/.exec(j)||[];return{browser:i[3]||i[1]||"",version:i[2]||"0",platform:h[0]||""}};a=e.uaMatch(d.navigator.userAgent);c={};if(a.browser){c[a.browser]=true;c.version=a.version;c.versionNumber=parseFloat(a.version,10)}if(a.platform){c[a.platform]=true}if(c.chrome||c.opr||c.safari){c.webkit=true}if(c.rv){var f="msie";a.browser=f;c[f]=true}if(c.opr){var b="opera";a.browser=b;c[b]=true}c.name=a.browser;c.platform=a.platform;e.browser=c})(jQuery,window);