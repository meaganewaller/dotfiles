!(async function () {
  for (; !Spicetify.React || !Spicetify.ReactDOM; ) await new Promise((e) => setTimeout(e, 10));
  var e,
    t,
    i,
    l,
    _,
    u,
    F,
    U,
    T,
    D,
    r,
    c,
    n,
    V,
    B,
    q,
    z,
    f,
    h,
    o,
    C,
    p,
    K,
    H,
    J,
    W,
    a,
    G,
    Y,
    X,
    Z,
    s,
    d,
    g,
    b,
    m,
    v,
    Q,
    y,
    ee,
    te,
    w,
    re,
    ne,
    ae,
    k,
    x,
    oe,
    S,
    se;
  (i = Object.create),
    (l = Object.defineProperty),
    (_ = Object.getOwnPropertyDescriptor),
    (u = Object.getOwnPropertyNames),
    (F = Object.getPrototypeOf),
    (U = Object.prototype.hasOwnProperty),
    (e = {
      'node_modules/.pnpm/chroma-js@2.4.2/node_modules/chroma-js/chroma.js'(e, t) {
        var r;
        (r = function () {
          'use strict';
          for (
            var e = function (e, t, r) {
                return void 0 === r && (r = 1), e < (t = void 0 === t ? 0 : t) ? t : r < e ? r : e;
              },
              _ = e,
              F = {},
              t = 0,
              U = ['Boolean', 'Number', 'String', 'Function', 'Array', 'Date', 'RegExp', 'Undefined', 'Null'];
            t < U.length;
            t += 1
          ) {
            var T = U[t];
            F['[object ' + T + ']'] = T.toLowerCase();
          }
          function r(e) {
            return F[Object.prototype.toString.call(e)] || 'object';
          }
          function D() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            if ('object' === Y(e[0]) && e[0].constructor && e[0].constructor === this.constructor) return e[0];
            var r = !1;
            if (!(o = W(e))) {
              (r = !0),
                i.sorted ||
                  ((i.autodetect = i.autodetect.sort(function (e, t) {
                    return t.p - e.p;
                  })),
                  (i.sorted = !0));
              for (var n = 0, a = i.autodetect; n < a.length; n += 1) {
                var o,
                  s = a[n];
                if ((o = s.test.apply(s, e))) break;
              }
            }
            if (!i.format[o]) throw new Error('unknown format: ' + e);
            (r = i.format[o].apply(null, r ? e : e.slice(0, -1))),
              (this._rgb = G(r)),
              3 === this._rgb.length && this._rgb.push(1);
          }
          function n() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            return new (Function.prototype.bind.apply(n.Color, [null].concat(e)))();
          }
          function V() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var r = (e = Q(e, 'cmyk'))[0],
              n = e[1],
              a = e[2],
              o = e[3],
              s = 4 < e.length ? e[4] : 1;
            return 1 === o
              ? [0, 0, 0, s]
              : [
                  1 <= r ? 0 : 255 * (1 - r) * (1 - o),
                  1 <= n ? 0 : 255 * (1 - n) * (1 - o),
                  1 <= a ? 0 : 255 * (1 - a) * (1 - o),
                  s,
                ];
          }
          function a(e) {
            return Math.round(100 * e) / 100;
          }
          function B() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var r,
              n,
              a = (e = se(e, 'rgba'))[0],
              o = e[1],
              s = e[2],
              i = ((a /= 255), (o /= 255), (s /= 255), Math.min(a, o, s)),
              l = Math.max(a, o, s),
              u = (l + i) / 2;
            return (
              l === i ? ((r = 0), (n = Number.NaN)) : (r = u < 0.5 ? (l - i) / (l + i) : (l - i) / (2 - l - i)),
              a == l
                ? (n = (o - s) / (l - i))
                : o == l
                  ? (n = 2 + (s - a) / (l - i))
                  : s == l && (n = 4 + (a - o) / (l - i)),
              (n *= 60) < 0 && (n += 360),
              3 < e.length && void 0 !== e[3] ? [n, r, u, e[3]] : [n, r, u]
            );
          }
          function q() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var r = ie(e, 'rgba'),
              n = le(e) || 'rgb';
            return 'hsl' == n.substr(0, 3)
              ? ue(ce(r), n)
              : ((r[0] = fe(r[0])),
                (r[1] = fe(r[1])),
                (r[2] = fe(r[2])),
                ('rgba' === n || (3 < r.length && r[3] < 1)) && ((r[3] = 3 < r.length ? r[3] : 1), (n = 'rgba')),
                n + '(' + r.slice(0, 'rgb' === n ? 3 : 4).join(',') + ')');
          }
          function z() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var r,
              n,
              a,
              o = (e = he(e, 'hsl'))[0],
              s = e[1],
              i = e[2];
            if (0 === s) r = n = a = 255 * i;
            else {
              var l = [0, 0, 0],
                u = [0, 0, 0],
                c = i < 0.5 ? i * (1 + s) : i + s - i * s,
                f = 2 * i - c,
                s = o / 360;
              (l[0] = s + 1 / 3), (l[1] = s), (l[2] = s - 1 / 3);
              for (var h = 0; h < 3; h++)
                l[h] < 0 && (l[h] += 1),
                  1 < l[h] && --l[h],
                  (u[h] =
                    6 * l[h] < 1
                      ? f + 6 * (c - f) * l[h]
                      : 2 * l[h] < 1
                        ? c
                        : 3 * l[h] < 2
                          ? f + (c - f) * (2 / 3 - l[h]) * 6
                          : f);
              (r = (i = [pe(255 * u[0]), pe(255 * u[1]), pe(255 * u[2])])[0]), (n = i[1]), (a = i[2]);
            }
            return 3 < e.length ? [r, n, a, e[3]] : [r, n, a, 1];
          }
          function K(e) {
            var t, r;
            if (((e = e.toLowerCase().trim()), ge.format.named))
              try {
                return ge.format.named(e);
              } catch (e) {}
            if ((t = e.match(be))) {
              for (var n = t.slice(1, 4), a = 0; a < 3; a++) n[a] = +n[a];
              return (n[3] = 1), n;
            }
            if ((t = e.match(me))) {
              for (var o = t.slice(1, 5), s = 0; s < 4; s++) o[s] = +o[s];
              return o;
            }
            if ((t = e.match(ve))) {
              for (var i = t.slice(1, 4), l = 0; l < 3; l++) i[l] = xe(2.55 * i[l]);
              return (i[3] = 1), i;
            }
            if ((t = e.match(ye))) {
              for (var u = t.slice(1, 5), c = 0; c < 3; c++) u[c] = xe(2.55 * u[c]);
              return (u[3] = +u[3]), u;
            }
            return (t = e.match(we))
              ? (((r = t.slice(1, 4))[1] *= 0.01), (r[2] *= 0.01), ((r = de(r))[3] = 1), r)
              : (t = e.match(ke))
                ? (((r = t.slice(1, 4))[1] *= 0.01), (r[2] *= 0.01), ((e = de(r))[3] = +t[4]), e)
                : void 0;
          }
          var H = r,
            J = r,
            o = Math.PI,
            e = {
              clip_rgb: function (e) {
                (e._clipped = !1), (e._unclipped = e.slice(0));
                for (var t = 0; t <= 3; t++)
                  t < 3
                    ? ((e[t] < 0 || 255 < e[t]) && (e._clipped = !0), (e[t] = _(e[t], 0, 255)))
                    : 3 === t && (e[t] = _(e[t], 0, 1));
                return e;
              },
              limit: e,
              type: r,
              unpack: function (t, e) {
                return (
                  void 0 === e && (e = null),
                  3 <= t.length
                    ? Array.prototype.slice.call(t)
                    : 'object' == H(t[0]) && e
                      ? e
                          .split('')
                          .filter(function (e) {
                            return void 0 !== t[0][e];
                          })
                          .map(function (e) {
                            return t[0][e];
                          })
                      : t[0]
                );
              },
              last: function (e) {
                var t;
                return !(e.length < 2) && ((t = e.length - 1), 'string' == J(e[t])) ? e[t].toLowerCase() : null;
              },
              PI: o,
              TWOPI: 2 * o,
              PITHIRD: o / 3,
              DEG2RAD: o / 180,
              RAD2DEG: 180 / o,
            },
            o = { format: {}, autodetect: [] },
            W = e.last,
            G = e.clip_rgb,
            Y = e.type,
            i = o,
            s =
              ((D.prototype.toString = function () {
                return 'function' == Y(this.hex) ? this.hex() : '[' + this._rgb.join(',') + ']';
              }),
              D),
            l = ((n.Color = s), (n.version = '2.4.2'), n),
            X = e.unpack,
            Z = Math.max,
            Q = e.unpack,
            u = l,
            ee = s,
            c = o,
            te = e.unpack,
            re = e.type,
            ne = function () {
              for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
              var r = X(e, 'rgb'),
                n = r[0],
                a = r[1],
                r = r[2],
                o = 1 - Z((n /= 255), Z((a /= 255), (r /= 255))),
                s = o < 1 ? 1 / (1 - o) : 0;
              return [(1 - n - o) * s, (1 - a - o) * s, (1 - r - o) * s, o];
            },
            ae =
              ((ee.prototype.cmyk = function () {
                return ne(this._rgb);
              }),
              (u.cmyk = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(ee, [null].concat(e, ['cmyk'])))();
              }),
              (c.format.cmyk = V),
              c.autodetect.push({
                p: 2,
                test: function () {
                  for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                  if (((e = te(e, 'cmyk')), 'array' === re(e) && 4 === e.length)) return 'cmyk';
                },
              }),
              e.unpack),
            oe = e.last,
            se = e.unpack,
            ie = e.unpack,
            le = e.last,
            ue = function () {
              for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
              var r = ae(e, 'hsla'),
                n = oe(e) || 'lsa';
              return (
                (r[0] = a(r[0] || 0)),
                (r[1] = a(100 * r[1]) + '%'),
                (r[2] = a(100 * r[2]) + '%'),
                'hsla' === n || (3 < r.length && r[3] < 1)
                  ? ((r[3] = 3 < r.length ? r[3] : 1), (n = 'hsla'))
                  : (r.length = 3),
                n + '(' + r.join(',') + ')'
              );
            },
            ce = B,
            fe = Math.round,
            he = e.unpack,
            pe = Math.round,
            de = z,
            ge = o,
            be = /^rgb\(\s*(-?\d+),\s*(-?\d+)\s*,\s*(-?\d+)\s*\)$/,
            me = /^rgba\(\s*(-?\d+),\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*([01]|[01]?\.\d+)\)$/,
            ve = /^rgb\(\s*(-?\d+(?:\.\d+)?)%,\s*(-?\d+(?:\.\d+)?)%\s*,\s*(-?\d+(?:\.\d+)?)%\s*\)$/,
            ye =
              /^rgba\(\s*(-?\d+(?:\.\d+)?)%,\s*(-?\d+(?:\.\d+)?)%\s*,\s*(-?\d+(?:\.\d+)?)%\s*,\s*([01]|[01]?\.\d+)\)$/,
            we = /^hsl\(\s*(-?\d+(?:\.\d+)?),\s*(-?\d+(?:\.\d+)?)%\s*,\s*(-?\d+(?:\.\d+)?)%\s*\)$/,
            ke =
              /^hsla\(\s*(-?\d+(?:\.\d+)?),\s*(-?\d+(?:\.\d+)?)%\s*,\s*(-?\d+(?:\.\d+)?)%\s*,\s*([01]|[01]?\.\d+)\)$/,
            xe = Math.round;
          K.test = function (e) {
            return be.test(e) || me.test(e) || ve.test(e) || ye.test(e) || we.test(e) || ke.test(e);
          };
          function Se() {
            for (var e, t = [], r = arguments.length; r--; ) t[r] = arguments[r];
            var n,
              a,
              o,
              s = (t = He(t, 'hcg'))[0],
              i = t[1],
              l = t[2],
              u = ((l *= 255), 255 * i);
            if (0 === i) n = a = o = l;
            else {
              360 < (s = 360 === s ? 0 : s) && (s -= 360), s < 0 && (s += 360);
              var c = Je((s /= 60)),
                s = s - c,
                f = l * (1 - i),
                h = f + u * (1 - s),
                p = f + u * s,
                d = f + u;
              switch (c) {
                case 0:
                  (n = (e = [d, p, f])[0]), (a = e[1]), (o = e[2]);
                  break;
                case 1:
                  (n = (e = [h, d, f])[0]), (a = e[1]), (o = e[2]);
                  break;
                case 2:
                  (n = (e = [f, d, p])[0]), (a = e[1]), (o = e[2]);
                  break;
                case 3:
                  (n = (e = [f, h, d])[0]), (a = e[1]), (o = e[2]);
                  break;
                case 4:
                  (n = (e = [p, f, d])[0]), (a = e[1]), (o = e[2]);
                  break;
                case 5:
                  (n = (e = [d, f, h])[0]), (a = e[1]), (o = e[2]);
              }
            }
            return [n, a, o, 3 < t.length ? t[3] : 1];
          }
          function Le() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var r = (o = Ze(e, 'rgba'))[0],
              n = o[1],
              a = o[2],
              o = o[3],
              s = Qe(e) || 'auto',
              i =
                (void 0 === o && (o = 1),
                'auto' === s && (s = o < 1 ? 'rgba' : 'rgb'),
                (i = '000000' + ((f(r) << 16) | (f(n) << 8) | f(a)).toString(16)).substr(i.length - 6)),
              l = (l = '0' + f(255 * o).toString(16)).substr(l.length - 2);
            switch (s.toLowerCase()) {
              case 'rgba':
                return '#' + i + l;
              case 'argb':
                return '#' + l + i;
              default:
                return '#' + i;
            }
          }
          function Oe(e) {
            var t;
            if (e.match(et))
              return (
                3 === (e = 4 !== e.length && 7 !== e.length ? e : e.substr(1)).length &&
                  (e = (e = e.split(''))[0] + e[0] + e[1] + e[1] + e[2] + e[2]),
                [(t = parseInt(e, 16)) >> 16, (t >> 8) & 255, 255 & t, 1]
              );
            if (e.match(tt))
              return (
                4 === (e = 5 !== e.length && 9 !== e.length ? e : e.substr(1)).length &&
                  (e = (e = e.split(''))[0] + e[0] + e[1] + e[1] + e[2] + e[2] + e[3] + e[3]),
                [
                  ((t = parseInt(e, 16)) >> 24) & 255,
                  (t >> 16) & 255,
                  (t >> 8) & 255,
                  Math.round(((255 & t) / 255) * 100) / 100,
                ]
              );
            throw new Error('unknown hex color: ' + e);
          }
          function Ne() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var r,
              n,
              a,
              o = (e = ct(e, 'hsi'))[0],
              s = e[1],
              i = e[2];
            return (
              isNaN(o) && (o = 0),
              isNaN(s) && (s = 0),
              360 < o && (o -= 360),
              o < 0 && (o += 360),
              (o /= 360) < 1 / 3
                ? (n = 1 - ((a = (1 - s) / 3) + (r = (1 + (s * p(h * o)) / p(ht - h * o)) / 3)))
                : o < 2 / 3
                  ? (a = 1 - ((r = (1 - s) / 3) + (n = (1 + (s * p(h * (o -= 1 / 3))) / p(ht - h * o)) / 3)))
                  : (r = 1 - ((n = (1 - s) / 3) + (a = (1 + (s * p(h * (o -= 2 / 3))) / p(ht - h * o)) / 3))),
              [255 * (r = ft(i * r * 3)), 255 * (n = ft(i * n * 3)), 255 * (a = ft(i * a * 3)), 3 < e.length ? e[3] : 1]
            );
          }
          function Re() {
            for (var e, t = [], r = arguments.length; r--; ) t[r] = arguments[r];
            var n,
              a,
              o,
              s = (t = Lt(t, 'hsv'))[0],
              i = t[1],
              l = t[2];
            if (((l *= 255), 0 === i)) n = a = o = l;
            else {
              360 < (s = 360 === s ? 0 : s) && (s -= 360), s < 0 && (s += 360);
              var u = Ot((s /= 60)),
                s = s - u,
                c = l * (1 - i),
                f = l * (1 - i * s),
                h = l * (1 - i * (1 - s));
              switch (u) {
                case 0:
                  (n = (e = [l, h, c])[0]), (a = e[1]), (o = e[2]);
                  break;
                case 1:
                  (n = (e = [f, l, c])[0]), (a = e[1]), (o = e[2]);
                  break;
                case 2:
                  (n = (e = [c, l, h])[0]), (a = e[1]), (o = e[2]);
                  break;
                case 3:
                  (n = (e = [c, f, l])[0]), (a = e[1]), (o = e[2]);
                  break;
                case 4:
                  (n = (e = [h, c, l])[0]), (a = e[1]), (o = e[2]);
                  break;
                case 5:
                  (n = (e = [l, c, f])[0]), (a = e[1]), (o = e[2]);
              }
            }
            return [n, a, o, 3 < t.length ? t[3] : 1];
          }
          function Ce() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var r = (a = jt(e, 'rgb'))[0],
              n = a[1],
              a = a[2];
            return (
              (n = n),
              (a = a),
              (r = Et((r = r))),
              (n = Et(n)),
              (a = Et(a)),
              [
                (a =
                  116 *
                    (n = (r = [
                      It((0.4124564 * r + 0.3575761 * n + 0.1804375 * a) / d.Xn),
                      It((0.2126729 * r + 0.7151522 * n + 0.072175 * a) / d.Yn),
                      It((0.0193339 * r + 0.119192 * n + 0.9503041 * a) / d.Zn),
                    ])[1]) -
                  16) < 0
                  ? 0
                  : a,
                500 * (r[0] - n),
                200 * (n - r[2]),
              ]
            );
          }
          function Pe(e) {
            return 255 * (e <= 0.00304 ? 12.92 * e : 1.055 * At(e, 1 / 2.4) - 0.055);
          }
          function je(e) {
            return e > g.t1 ? e * e * e : g.t2 * (e - g.t0);
          }
          function Me() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var r = (e = $t(e, 'lab'))[0],
              n = e[1],
              a = e[2],
              r = (r + 16) / 116,
              n = isNaN(n) ? r : r + n / 500,
              a = isNaN(a) ? r : r - a / 200;
            return (
              (r = g.Yn * je(r)),
              (n = g.Xn * je(n)),
              (a = g.Zn * je(a)),
              [
                Pe(3.2404542 * n - 1.5371385 * r - 0.4985314 * a),
                Pe(-0.969266 * n + 1.8760108 * r + 0.041556 * a),
                Pe(0.0556434 * n - 0.2040259 * r + 1.0572252 * a),
                3 < e.length ? e[3] : 1,
              ]
            );
          }
          function Ee() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var r = (a = Dt(e, 'lab'))[0],
              n = a[1],
              a = a[2],
              o = Bt(n * n + a * a),
              a = (qt(a, n) * Vt + 360) % 360;
            return [r, o, (a = 0 === zt(1e4 * o) ? Number.NaN : a)];
          }
          function Ie() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var r = (a = Wt(e, 'lch'))[0],
              n = a[1],
              a = a[2];
            return isNaN(a) && (a = 0), [r, Xt((a *= Gt)) * n, Yt(a) * n];
          }
          function $e() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var r = (e = Zt(e, 'lch'))[0],
              n = e[1],
              a = e[2],
              n = (r = Qt(r, n, a))[0],
              a = r[1],
              r = r[2];
            return [(n = er(n, a, r))[0], n[1], n[2], 3 < e.length ? e[3] : 1];
          }
          function Ae() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var r = tr(e, 'hcl').reverse();
            return rr.apply(void 0, r);
          }
          function _e(e) {
            if ('number' == fr(e) && 0 <= e && e <= 16777215) return [e >> 16, (e >> 8) & 255, 255 & e, 1];
            throw new Error('unknown num color: ' + e);
          }
          function Fe(e) {
            var t,
              r,
              n =
                (e = e / 100) < 66
                  ? ((t = 255),
                    (r =
                      e < 6 ? 0 : -155.25485562709179 - 0.44596950469579133 * (r = e - 2) + 104.49216199393888 * w(r)),
                    e < 20 ? 0 : 0.8274096064007395 * (n = e - 10) - 254.76935184120902 + 115.67994401066147 * w(n))
                  : ((t = 351.97690566805693 + 0.114206453784165 * (t = e - 55) - 40.25366309332127 * w(t)),
                    (r = 325.4494125711974 + 0.07943456536662342 * (r = e - 50) - 28.0852963507957 * w(r)),
                    255);
            return [t, r, n, 1];
          }
          function Ue() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var r = (a = Sr(e, 'rgb'))[0],
              n = a[1],
              a = a[2],
              r = [Rr(r / 255), Rr(n / 255), Rr(a / 255)],
              o = Lr(0.4122214708 * (n = r[0]) + 0.5363325363 * (a = r[1]) + 0.0514459929 * (r = r[2])),
              s = Lr(0.2119034982 * n + 0.6806995451 * a + 0.1073969566 * r),
              n = Lr(0.0883024619 * n + 0.2817188376 * a + 0.6299787005 * r);
            return [
              0.2104542553 * o + 0.793617785 * s - 0.0040720468 * n,
              1.9779984951 * o - 2.428592205 * s + 0.4505937099 * n,
              0.0259040371 * o + 0.7827717662 * s - 0.808675766 * n,
            ];
          }
          var u = l,
            Te = s,
            c = o,
            De = e.type,
            Ve = q,
            Be = K,
            qe =
              ((Te.prototype.css = function (e) {
                return Ve(this._rgb, e);
              }),
              (u.css = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(Te, [null].concat(e, ['css'])))();
              }),
              (c.format.css = Be),
              c.autodetect.push({
                p: 5,
                test: function (e) {
                  for (var t = [], r = arguments.length - 1; 0 < r--; ) t[r] = arguments[r + 1];
                  if (!t.length && 'string' === De(e) && Be.test(e)) return 'css';
                },
              }),
              s),
            u = l,
            c = o,
            ze = e.unpack,
            Ke =
              ((c.format.gl = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                var r = ze(e, 'rgba');
                return (r[0] *= 255), (r[1] *= 255), (r[2] *= 255), r;
              }),
              (u.gl = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(qe, [null].concat(e, ['gl'])))();
              }),
              (qe.prototype.gl = function () {
                var e = this._rgb;
                return [e[0] / 255, e[1] / 255, e[2] / 255, e[3]];
              }),
              e.unpack),
            He = e.unpack,
            Je = Math.floor,
            We = e.unpack,
            Ge = e.type,
            c = l,
            Ye = s,
            u = o,
            Xe = function () {
              for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
              var r,
                n = Ke(e, 'rgb'),
                a = n[0],
                o = n[1],
                n = n[2],
                s = Math.min(a, o, n),
                i = Math.max(a, o, n),
                l = i - s;
              return (
                0 == l
                  ? (r = Number.NaN)
                  : (a === i && (r = (o - n) / l),
                    o === i && (r = 2 + (n - a) / l),
                    n === i && (r = 4 + (a - o) / l),
                    (r *= 60) < 0 && (r += 360)),
                [r, (100 * l) / 255, (s / (255 - l)) * 100]
              );
            },
            Ze =
              ((Ye.prototype.hcg = function () {
                return Xe(this._rgb);
              }),
              (c.hcg = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(Ye, [null].concat(e, ['hcg'])))();
              }),
              (u.format.hcg = Se),
              u.autodetect.push({
                p: 1,
                test: function () {
                  for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                  if (((e = We(e, 'hcg')), 'array' === Ge(e) && 3 === e.length)) return 'hcg';
                },
              }),
              e.unpack),
            Qe = e.last,
            f = Math.round,
            et = /^#?([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/,
            tt = /^#?([A-Fa-f0-9]{8}|[A-Fa-f0-9]{4})$/,
            c = l,
            rt = s,
            nt = e.type,
            u = o,
            at = Le,
            ot =
              ((rt.prototype.hex = function (e) {
                return at(this._rgb, e);
              }),
              (c.hex = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(rt, [null].concat(e, ['hex'])))();
              }),
              (u.format.hex = Oe),
              u.autodetect.push({
                p: 4,
                test: function (e) {
                  for (var t = [], r = arguments.length - 1; 0 < r--; ) t[r] = arguments[r + 1];
                  if (!t.length && 'string' === nt(e) && 0 <= [3, 4, 5, 6, 7, 8, 9].indexOf(e.length)) return 'hex';
                },
              }),
              e.unpack),
            st = e.TWOPI,
            it = Math.min,
            lt = Math.sqrt,
            ut = Math.acos,
            ct = e.unpack,
            ft = e.limit,
            h = e.TWOPI,
            ht = e.PITHIRD,
            p = Math.cos,
            pt = e.unpack,
            dt = e.type,
            c = l,
            gt = s,
            u = o,
            bt = function () {
              for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
              var r,
                n = ot(e, 'rgb'),
                a = n[0],
                o = n[1],
                n = n[2],
                s = it((a /= 255), (o /= 255), (n /= 255)),
                i = (a + o + n) / 3,
                s = 0 < i ? 1 - s / i : 0;
              return (
                0 == s
                  ? (r = NaN)
                  : ((r = (a - o + (a - n)) / 2),
                    (r /= lt((a - o) * (a - o) + (a - n) * (o - n))),
                    (r = ut(r)),
                    o < n && (r = st - r),
                    (r /= st)),
                [360 * r, s, i]
              );
            },
            mt =
              ((gt.prototype.hsi = function () {
                return bt(this._rgb);
              }),
              (c.hsi = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(gt, [null].concat(e, ['hsi'])))();
              }),
              (u.format.hsi = Ne),
              u.autodetect.push({
                p: 2,
                test: function () {
                  for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                  if (((e = pt(e, 'hsi')), 'array' === dt(e) && 3 === e.length)) return 'hsi';
                },
              }),
              e.unpack),
            vt = e.type,
            c = l,
            yt = s,
            u = o,
            wt = B,
            kt =
              ((yt.prototype.hsl = function () {
                return wt(this._rgb);
              }),
              (c.hsl = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(yt, [null].concat(e, ['hsl'])))();
              }),
              (u.format.hsl = z),
              u.autodetect.push({
                p: 2,
                test: function () {
                  for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                  if (((e = mt(e, 'hsl')), 'array' === vt(e) && 3 === e.length)) return 'hsl';
                },
              }),
              e.unpack),
            xt = Math.min,
            St = Math.max,
            Lt = e.unpack,
            Ot = Math.floor,
            Nt = e.unpack,
            Rt = e.type,
            c = l,
            Ct = s,
            u = o,
            Pt = function () {
              for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
              var r,
                n,
                a = (e = kt(e, 'rgb'))[0],
                o = e[1],
                s = e[2],
                i = xt(a, o, s),
                l = St(a, o, s),
                i = l - i;
              return (
                0 === l
                  ? ((r = Number.NaN), (n = 0))
                  : ((n = i / l),
                    a === l && (r = (o - s) / i),
                    o === l && (r = 2 + (s - a) / i),
                    s === l && (r = 4 + (a - o) / i),
                    (r *= 60) < 0 && (r += 360)),
                [r, n, l / 255]
              );
            },
            c =
              ((Ct.prototype.hsv = function () {
                return Pt(this._rgb);
              }),
              (c.hsv = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(Ct, [null].concat(e, ['hsv'])))();
              }),
              (u.format.hsv = Re),
              u.autodetect.push({
                p: 2,
                test: function () {
                  for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                  if (((e = Nt(e, 'hsv')), 'array' === Rt(e) && 3 === e.length)) return 'hsv';
                },
              }),
              {
                Kn: 18,
                Xn: 0.95047,
                Yn: 1,
                Zn: 1.08883,
                t0: 0.137931034,
                t1: 0.206896552,
                t2: 0.12841855,
                t3: 0.008856452,
              }),
            d = c,
            jt = e.unpack,
            Mt = Math.pow,
            Et = function (e) {
              return (e /= 255) <= 0.04045 ? e / 12.92 : Mt((e + 0.055) / 1.055, 2.4);
            },
            It = function (e) {
              return e > d.t3 ? Mt(e, 1 / 3) : e / d.t2 + d.t0;
            },
            g = c,
            $t = e.unpack,
            At = Math.pow,
            _t = e.unpack,
            Ft = e.type,
            u = l,
            Ut = s,
            b = o,
            Tt = Ce,
            Dt =
              ((Ut.prototype.lab = function () {
                return Tt(this._rgb);
              }),
              (u.lab = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(Ut, [null].concat(e, ['lab'])))();
              }),
              (b.format.lab = Me),
              b.autodetect.push({
                p: 2,
                test: function () {
                  for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                  if (((e = _t(e, 'lab')), 'array' === Ft(e) && 3 === e.length)) return 'lab';
                },
              }),
              e.unpack),
            Vt = e.RAD2DEG,
            Bt = Math.sqrt,
            qt = Math.atan2,
            zt = Math.round,
            Kt = e.unpack,
            Ht = Ce,
            Jt = Ee,
            Wt = e.unpack,
            Gt = e.DEG2RAD,
            Yt = Math.sin,
            Xt = Math.cos,
            Zt = e.unpack,
            Qt = Ie,
            er = Me,
            tr = e.unpack,
            rr = $e,
            nr = e.unpack,
            ar = e.type,
            u = l,
            m = s,
            or = o,
            sr = function () {
              for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
              var r = Kt(e, 'rgb'),
                n = r[0],
                a = r[1],
                r = r[2],
                n = Ht(n, a, r),
                a = n[0],
                r = n[1],
                n = n[2];
              return Jt(a, r, n);
            },
            b =
              ((m.prototype.lch = function () {
                return sr(this._rgb);
              }),
              (m.prototype.hcl = function () {
                return sr(this._rgb).reverse();
              }),
              (u.lch = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(m, [null].concat(e, ['lch'])))();
              }),
              (u.hcl = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(m, [null].concat(e, ['hcl'])))();
              }),
              (or.format.lch = $e),
              (or.format.hcl = Ae),
              ['lch', 'hcl'].forEach(function (r) {
                return or.autodetect.push({
                  p: 2,
                  test: function () {
                    for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                    if (((e = nr(e, r)), 'array' === ar(e) && 3 === e.length)) return r;
                  },
                });
              }),
              {
                aliceblue: '#f0f8ff',
                antiquewhite: '#faebd7',
                aqua: '#00ffff',
                aquamarine: '#7fffd4',
                azure: '#f0ffff',
                beige: '#f5f5dc',
                bisque: '#ffe4c4',
                black: '#000000',
                blanchedalmond: '#ffebcd',
                blue: '#0000ff',
                blueviolet: '#8a2be2',
                brown: '#a52a2a',
                burlywood: '#deb887',
                cadetblue: '#5f9ea0',
                chartreuse: '#7fff00',
                chocolate: '#d2691e',
                coral: '#ff7f50',
                cornflower: '#6495ed',
                cornflowerblue: '#6495ed',
                cornsilk: '#fff8dc',
                crimson: '#dc143c',
                cyan: '#00ffff',
                darkblue: '#00008b',
                darkcyan: '#008b8b',
                darkgoldenrod: '#b8860b',
                darkgray: '#a9a9a9',
                darkgreen: '#006400',
                darkgrey: '#a9a9a9',
                darkkhaki: '#bdb76b',
                darkmagenta: '#8b008b',
                darkolivegreen: '#556b2f',
                darkorange: '#ff8c00',
                darkorchid: '#9932cc',
                darkred: '#8b0000',
                darksalmon: '#e9967a',
                darkseagreen: '#8fbc8f',
                darkslateblue: '#483d8b',
                darkslategray: '#2f4f4f',
                darkslategrey: '#2f4f4f',
                darkturquoise: '#00ced1',
                darkviolet: '#9400d3',
                deeppink: '#ff1493',
                deepskyblue: '#00bfff',
                dimgray: '#696969',
                dimgrey: '#696969',
                dodgerblue: '#1e90ff',
                firebrick: '#b22222',
                floralwhite: '#fffaf0',
                forestgreen: '#228b22',
                fuchsia: '#ff00ff',
                gainsboro: '#dcdcdc',
                ghostwhite: '#f8f8ff',
                gold: '#ffd700',
                goldenrod: '#daa520',
                gray: '#808080',
                green: '#008000',
                greenyellow: '#adff2f',
                grey: '#808080',
                honeydew: '#f0fff0',
                hotpink: '#ff69b4',
                indianred: '#cd5c5c',
                indigo: '#4b0082',
                ivory: '#fffff0',
                khaki: '#f0e68c',
                laserlemon: '#ffff54',
                lavender: '#e6e6fa',
                lavenderblush: '#fff0f5',
                lawngreen: '#7cfc00',
                lemonchiffon: '#fffacd',
                lightblue: '#add8e6',
                lightcoral: '#f08080',
                lightcyan: '#e0ffff',
                lightgoldenrod: '#fafad2',
                lightgoldenrodyellow: '#fafad2',
                lightgray: '#d3d3d3',
                lightgreen: '#90ee90',
                lightgrey: '#d3d3d3',
                lightpink: '#ffb6c1',
                lightsalmon: '#ffa07a',
                lightseagreen: '#20b2aa',
                lightskyblue: '#87cefa',
                lightslategray: '#778899',
                lightslategrey: '#778899',
                lightsteelblue: '#b0c4de',
                lightyellow: '#ffffe0',
                lime: '#00ff00',
                limegreen: '#32cd32',
                linen: '#faf0e6',
                magenta: '#ff00ff',
                maroon: '#800000',
                maroon2: '#7f0000',
                maroon3: '#b03060',
                mediumaquamarine: '#66cdaa',
                mediumblue: '#0000cd',
                mediumorchid: '#ba55d3',
                mediumpurple: '#9370db',
                mediumseagreen: '#3cb371',
                mediumslateblue: '#7b68ee',
                mediumspringgreen: '#00fa9a',
                mediumturquoise: '#48d1cc',
                mediumvioletred: '#c71585',
                midnightblue: '#191970',
                mintcream: '#f5fffa',
                mistyrose: '#ffe4e1',
                moccasin: '#ffe4b5',
                navajowhite: '#ffdead',
                navy: '#000080',
                oldlace: '#fdf5e6',
                olive: '#808000',
                olivedrab: '#6b8e23',
                orange: '#ffa500',
                orangered: '#ff4500',
                orchid: '#da70d6',
                palegoldenrod: '#eee8aa',
                palegreen: '#98fb98',
                paleturquoise: '#afeeee',
                palevioletred: '#db7093',
                papayawhip: '#ffefd5',
                peachpuff: '#ffdab9',
                peru: '#cd853f',
                pink: '#ffc0cb',
                plum: '#dda0dd',
                powderblue: '#b0e0e6',
                purple: '#800080',
                purple2: '#7f007f',
                purple3: '#a020f0',
                rebeccapurple: '#663399',
                red: '#ff0000',
                rosybrown: '#bc8f8f',
                royalblue: '#4169e1',
                saddlebrown: '#8b4513',
                salmon: '#fa8072',
                sandybrown: '#f4a460',
                seagreen: '#2e8b57',
                seashell: '#fff5ee',
                sienna: '#a0522d',
                silver: '#c0c0c0',
                skyblue: '#87ceeb',
                slateblue: '#6a5acd',
                slategray: '#708090',
                slategrey: '#708090',
                snow: '#fffafa',
                springgreen: '#00ff7f',
                steelblue: '#4682b4',
                tan: '#d2b48c',
                teal: '#008080',
                thistle: '#d8bfd8',
                tomato: '#ff6347',
                turquoise: '#40e0d0',
                violet: '#ee82ee',
                wheat: '#f5deb3',
                white: '#ffffff',
                whitesmoke: '#f5f5f5',
                yellow: '#ffff00',
                yellowgreen: '#9acd32',
              }),
            u = s,
            v = o,
            ir = e.type,
            y = b,
            lr = Oe,
            ur = Le,
            cr =
              ((u.prototype.name = function () {
                for (var e = ur(this._rgb, 'rgb'), t = 0, r = Object.keys(y); t < r.length; t += 1) {
                  var n = r[t];
                  if (y[n] === e) return n.toLowerCase();
                }
                return e;
              }),
              (v.format.named = function (e) {
                if (((e = e.toLowerCase()), y[e])) return lr(y[e]);
                throw new Error('unknown color name: ' + e);
              }),
              v.autodetect.push({
                p: 5,
                test: function (e) {
                  for (var t = [], r = arguments.length - 1; 0 < r--; ) t[r] = arguments[r + 1];
                  if (!t.length && 'string' === ir(e) && y[e.toLowerCase()]) return 'named';
                },
              }),
              e.unpack),
            fr = e.type,
            u = l,
            hr = s,
            v = o,
            pr = e.type,
            dr = function () {
              for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
              var r = cr(e, 'rgb');
              return (r[0] << 16) + (r[1] << 8) + r[2];
            },
            u =
              ((hr.prototype.num = function () {
                return dr(this._rgb);
              }),
              (u.num = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(hr, [null].concat(e, ['num'])))();
              }),
              (v.format.num = _e),
              v.autodetect.push({
                p: 5,
                test: function () {
                  for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                  if (1 === e.length && 'number' === pr(e[0]) && 0 <= e[0] && e[0] <= 16777215) return 'num';
                },
              }),
              l),
            gr = s,
            v = o,
            br = e.unpack,
            mr = e.type,
            vr = Math.round,
            w =
              ((gr.prototype.rgb = function (e) {
                return !1 === (e = void 0 === e ? !0 : e) ? this._rgb.slice(0, 3) : this._rgb.slice(0, 3).map(vr);
              }),
              (gr.prototype.rgba = function (r) {
                return (
                  void 0 === r && (r = !0),
                  this._rgb.slice(0, 4).map(function (e, t) {
                    return !(t < 3) || !1 === r ? e : vr(e);
                  })
                );
              }),
              (u.rgb = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(gr, [null].concat(e, ['rgb'])))();
              }),
              (v.format.rgb = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                var r = br(e, 'rgba');
                return void 0 === r[3] && (r[3] = 1), r;
              }),
              v.autodetect.push({
                p: 3,
                test: function () {
                  for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                  if (
                    ((e = br(e, 'rgba')),
                    'array' === mr(e) &&
                      (3 === e.length || (4 === e.length && 'number' == mr(e[3]) && 0 <= e[3] && e[3] <= 1)))
                  )
                    return 'rgb';
                },
              }),
              Math.log),
            yr = Fe,
            wr = e.unpack,
            kr = Math.round,
            u = l,
            k = s,
            v = o,
            xr = function () {
              for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
              for (var r = wr(e, 'rgb'), n = r[0], a = r[2], o = 1e3, s = 4e4; 0.4 < s - o; ) {
                var i,
                  l = yr((i = 0.5 * (s + o)));
                l[2] / l[0] >= a / n ? (s = i) : (o = i);
              }
              return kr(i);
            },
            Sr =
              ((k.prototype.temp =
                k.prototype.kelvin =
                k.prototype.temperature =
                  function () {
                    return xr(this._rgb);
                  }),
              (u.temp =
                u.kelvin =
                u.temperature =
                  function () {
                    for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                    return new (Function.prototype.bind.apply(k, [null].concat(e, ['temp'])))();
                  }),
              (v.format.temp = v.format.kelvin = v.format.temperature = Fe),
              e.unpack),
            Lr = Math.cbrt,
            Or = Math.pow,
            Nr = Math.sign;
          function Rr(e) {
            var t = Math.abs(e);
            return t < 0.04045 ? e / 12.92 : (Nr(e) || 1) * Or((t + 0.055) / 1.055, 2.4);
          }
          function Cr() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var r = (e = Pr(e, 'lab'))[0],
              n = e[1],
              a = e[2],
              o = x(r + 0.3963377774 * n + 0.2158037573 * a, 3),
              s = x(r - 0.1055613458 * n - 0.0638541728 * a, 3),
              r = x(r - 0.0894841775 * n - 1.291485548 * a, 3);
            return [
              255 * Mr(4.0767416621 * o - 3.3077115913 * s + 0.2309699292 * r),
              255 * Mr(-1.2684380046 * o + 2.6097574011 * s - 0.3413193965 * r),
              255 * Mr(-0.0041960863 * o - 0.7034186147 * s + 1.707614701 * r),
              3 < e.length ? e[3] : 1,
            ];
          }
          var Pr = e.unpack,
            x = Math.pow,
            jr = Math.sign;
          function Mr(e) {
            var t = Math.abs(e);
            return 0.0031308 < t ? (jr(e) || 1) * (1.055 * x(t, 1 / 2.4) - 0.055) : 12.92 * e;
          }
          function Er() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var r = (e = Dr(e, 'lch'))[0],
              n = e[1],
              a = e[2],
              n = (r = Vr(r, n, a))[0],
              a = r[1],
              r = r[2];
            return [(n = Br(n, a, r))[0], n[1], n[2], 3 < e.length ? e[3] : 1];
          }
          var Ir = e.unpack,
            $r = e.type,
            u = l,
            Ar = s,
            v = o,
            _r = Ue,
            Fr =
              ((Ar.prototype.oklab = function () {
                return _r(this._rgb);
              }),
              (u.oklab = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(Ar, [null].concat(e, ['oklab'])))();
              }),
              (v.format.oklab = Cr),
              v.autodetect.push({
                p: 3,
                test: function () {
                  for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                  if (((e = Ir(e, 'oklab')), 'array' === $r(e) && 3 === e.length)) return 'oklab';
                },
              }),
              e.unpack),
            Ur = Ue,
            Tr = Ee,
            Dr = e.unpack,
            Vr = Ie,
            Br = Cr,
            qr = e.unpack,
            zr = e.type,
            u = l,
            Kr = s,
            v = o,
            Hr = function () {
              for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
              var r = Fr(e, 'rgb'),
                n = r[0],
                a = r[1],
                r = r[2],
                n = Ur(n, a, r),
                a = n[0],
                r = n[1],
                n = n[2];
              return Tr(a, r, n);
            },
            Jr =
              ((Kr.prototype.oklch = function () {
                return Hr(this._rgb);
              }),
              (u.oklch = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(Kr, [null].concat(e, ['oklch'])))();
              }),
              (v.format.oklch = Er),
              v.autodetect.push({
                p: 3,
                test: function () {
                  for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                  if (((e = qr(e, 'oklch')), 'array' === zr(e) && 3 === e.length)) return 'oklch';
                },
              }),
              s),
            Wr = e.type;
          Jr.prototype.alpha = function (e, t) {
            return (
              void 0 === t && (t = !1),
              void 0 !== e && 'number' === Wr(e)
                ? t
                  ? ((this._rgb[3] = e), this)
                  : new Jr([this._rgb[0], this._rgb[1], this._rgb[2], e], 'rgb')
                : this._rgb[3]
            );
          };
          s.prototype.clipped = function () {
            return this._rgb._clipped || !1;
          };
          var S = s,
            Gr = c;
          (S.prototype.darken = function (e) {
            void 0 === e && (e = 1);
            var t = this.lab();
            return (t[0] -= Gr.Kn * e), new S(t, 'lab').alpha(this.alpha(), !0);
          }),
            (S.prototype.brighten = function (e) {
              return this.darken(-(e = void 0 === e ? 1 : e));
            }),
            (S.prototype.darker = S.prototype.darken),
            (S.prototype.brighter = S.prototype.brighten);
          function Yr(e, t, r) {
            void 0 === r && (r = 0.5);
            for (var n = [], a = arguments.length - 3; 0 < a--; ) n[a] = arguments[a + 3];
            var o = n[0] || 'lrgb';
            if ((N[o] || n.length || (o = Object.keys(N)[0]), N[o]))
              return (
                'object' !== an(e) && (e = new nn(e)),
                'object' !== an(t) && (t = new nn(t)),
                N[o](e, t, r).alpha(e.alpha() + r * (t.alpha() - e.alpha()))
              );
            throw new Error('interpolation mode ' + o + ' is not defined');
          }
          function L(e, t, r, n) {
            var a, o, s, i, l, u, c, f, h, p;
            return (
              'hsl' === n
                ? ((p = e.hsl()), (a = t.hsl()))
                : 'hsv' === n
                  ? ((p = e.hsv()), (a = t.hsv()))
                  : 'hcg' === n
                    ? ((p = e.hcg()), (a = t.hcg()))
                    : 'hsi' === n
                      ? ((p = e.hsi()), (a = t.hsi()))
                      : 'lch' === n || 'hcl' === n
                        ? ((n = 'hcl'), (p = e.hcl()), (a = t.hcl()))
                        : 'oklch' === n && ((p = e.oklch().reverse()), (a = t.oklch().reverse())),
              ('h' !== n.substr(0, 1) && 'oklch' !== n) ||
                ((o = (e = p)[0]), (i = e[1]), (u = e[2]), (s = (t = a)[0]), (l = t[1]), (c = t[2])),
              isNaN(o) || isNaN(s)
                ? isNaN(o)
                  ? isNaN(s)
                    ? (h = Number.NaN)
                    : ((h = s), (1 != u && 0 != u) || 'hsv' == n || (f = l))
                  : ((h = o), (1 != c && 0 != c) || 'hsv' == n || (f = i))
                : (h = o + r * (o < s && 180 < s - o ? s - (o + 360) : s < o && 180 < o - s ? s + 360 - o : s - o)),
              void 0 === f && (f = i + r * (l - i)),
              (p = u + r * (c - u)),
              new bn('oklch' === n ? [p, f, h] : [h, f, p], n)
            );
          }
          function Xr(e, t, r) {
            return mn(e, t, r, 'lch');
          }
          function Zr(u) {
            function r(e) {
              if (
                ((e = e || ['#fff', '#000']) &&
                  'string' === P(e) &&
                  C.brewer &&
                  C.brewer[e.toLowerCase()] &&
                  (e = C.brewer[e.toLowerCase()]),
                'array' === P(e))
              ) {
                e = (e = 1 === e.length ? [e[0], e[0]] : e).slice(0);
                for (var t = 0; t < e.length; t++) e[t] = C(e[t]);
                for (var r = (l.length = 0); r < e.length; r++) l.push(r / (e.length - 1));
              }
              n(), (g = e);
            }
            function c(e, t) {
              var r, n;
              if ((null == t && (t = !1), isNaN(e) || null === e)) return i;
              if (
                ((n = t ? e : d && 2 < d.length ? k(e) / (d.length - 2) : m !== b ? (e - b) / (m - b) : 1),
                (n = S(n)),
                t || (n = x(n)),
                1 !== w && (n = In(n, w)),
                (n = p[0] + n * (1 - p[0] - p[1])),
                (n = Math.min(1, Math.max(0, n))),
                (e = Math.floor(1e4 * n)),
                y && v[e])
              )
                r = v[e];
              else {
                if ('array' === P(g))
                  for (var a = 0; a < l.length; a++) {
                    var o = l[a];
                    if (n <= o) {
                      r = g[a];
                      break;
                    }
                    if (o <= n && a === l.length - 1) {
                      r = g[a];
                      break;
                    }
                    if (o < n && n < l[a + 1]) {
                      (n = (n - o) / (l[a + 1] - o)), (r = C.interpolate(g[a], g[a + 1], n, s));
                      break;
                    }
                  }
                else 'function' === P(g) && (r = g(n));
                y && (v[e] = r);
              }
              return r;
            }
            function n() {
              v = {};
            }
            function f(e) {
              return (e = C(c(e))), a && e[a] ? e[a]() : e;
            }
            var s = 'rgb',
              i = C('#ccc'),
              t = 0,
              h = [0, 1],
              l = [],
              p = [0, 0],
              d = !1,
              g = [],
              a = !1,
              b = 0,
              m = 1,
              v = {},
              y = !0,
              w = 1,
              k = function (e) {
                if (null == d) return 0;
                for (var t = d.length - 1, r = 0; r < t && e >= d[r]; ) r++;
                return r - 1;
              },
              x = function (e) {
                return e;
              },
              S = function (e) {
                return e;
              };
            return (
              r(u),
              (f.classes = function (e) {
                var t;
                return null != e
                  ? ('array' === P(e)
                      ? (h = [(d = e)[0], e[e.length - 1]])
                      : ((t = C.analyze(h)), (d = 0 === e ? [t.min, t.max] : C.limits(t, 'e', e))),
                    f)
                  : d;
              }),
              (f.domain = function (r) {
                if (!arguments.length) return h;
                (b = r[0]), (m = r[r.length - 1]), (l = []);
                var e = g.length;
                if (r.length === e && b !== m)
                  for (var t = 0, n = Array.from(r); t < n.length; t += 1) {
                    var a = n[t];
                    l.push((a - b) / (m - b));
                  }
                else {
                  for (var o, s, i = 0; i < e; i++) l.push(i / (e - 1));
                  2 < r.length &&
                    ((o = r.map(function (e, t) {
                      return t / (r.length - 1);
                    })),
                    (s = r.map(function (e) {
                      return (e - b) / (m - b);
                    })).every(function (e, t) {
                      return o[t] === e;
                    }) ||
                      (S = function (e) {
                        if (e <= 0 || 1 <= e) return e;
                        for (var t = 0; e >= s[t + 1]; ) t++;
                        var r = (e - s[t]) / (s[t + 1] - s[t]);
                        return o[t] + r * (o[t + 1] - o[t]);
                      }));
                }
                return (h = [b, m]), f;
              }),
              (f.mode = function (e) {
                return arguments.length ? ((s = e), n(), f) : s;
              }),
              (f.range = function (e, t) {
                return r(e), f;
              }),
              (f.out = function (e) {
                return (a = e), f;
              }),
              (f.spread = function (e) {
                return arguments.length ? ((t = e), f) : t;
              }),
              (f.correctLightness = function (e) {
                return (
                  n(),
                  (x = (e = null == e ? !0 : e)
                    ? function (e) {
                        for (
                          var t = c(0, !0).lab()[0],
                            r = c(1, !0).lab()[0],
                            n = r < t,
                            a = c(e, !0).lab()[0],
                            o = t + (r - t) * e,
                            s = a - o,
                            i = 0,
                            l = 1,
                            u = 20;
                          0.01 < Math.abs(s) && 0 < u--;

                        )
                          n && (s *= -1),
                            (e += s < 0 ? 0.5 * (l - (i = e)) : 0.5 * (i - (l = e))),
                            (a = c(e, !0).lab()[0]),
                            (s = a - o);
                        return e;
                      }
                    : function (e) {
                        return e;
                      }),
                  f
                );
              }),
              (f.padding = function (e) {
                return null != e ? ('number' === P(e) && (e = [e, e]), (p = e), f) : p;
              }),
              (f.colors = function (t, r) {
                arguments.length < 2 && (r = 'hex');
                var e = [];
                if (0 === arguments.length) e = g.slice(0);
                else if (1 === t) e = [f(0.5)];
                else if (1 < t)
                  var n = h[0],
                    a = h[1] - n,
                    e = (function (e, t, r) {
                      for (
                        var n = [], a = e < t, o = r ? (a ? t + 1 : t - 1) : t, s = e;
                        a ? s < o : o < s;
                        a ? s++ : s--
                      )
                        n.push(s);
                      return n;
                    })(0, t, !1).map(function (e) {
                      return f(n + (e / (t - 1)) * a);
                    });
                else {
                  u = [];
                  var o = [];
                  if (d && 2 < d.length)
                    for (var s = 1, i = d.length, l = 1 <= i; l ? s < i : i < s; l ? s++ : s--)
                      o.push(0.5 * (d[s - 1] + d[s]));
                  else o = h;
                  e = o.map(f);
                }
                return (e = C[r]
                  ? e.map(function (e) {
                      return e[r]();
                    })
                  : e);
              }),
              (f.cache = function (e) {
                return null != e ? ((y = e), f) : y;
              }),
              (f.gamma = function (e) {
                return null != e ? ((w = e), f) : w;
              }),
              (f.nodata = function (e) {
                return null != e ? ((i = C(e)), f) : i;
              }),
              f
            );
          }
          s.prototype.get = function (e) {
            var e = e.split('.'),
              t = e[0],
              e = e[1],
              r = this[t]();
            if (e) {
              var n = t.indexOf(e) - ('ok' === t.substr(0, 2) ? 2 : 0);
              if (-1 < n) return r[n];
              throw new Error('unknown channel ' + e + ' in mode ' + t);
            }
            return r;
          };
          var O = s,
            Qr = e.type,
            en = Math.pow,
            tn =
              ((O.prototype.luminance = function (a) {
                var o, s, i, e;
                return void 0 !== a && 'number' === Qr(a)
                  ? 0 === a
                    ? new O([0, 0, 0, this._rgb[3]], 'rgb')
                    : 1 === a
                      ? new O([255, 255, 255, this._rgb[3]], 'rgb')
                      : ((e = this.luminance()),
                        (o = 'rgb'),
                        (s = 20),
                        (i = function (e, t) {
                          var r = e.interpolate(t, 0.5, o),
                            n = r.luminance();
                          return Math.abs(a - n) < 1e-7 || !s-- ? r : a < n ? i(e, r) : i(r, t);
                        }),
                        (e = (a < e ? i(new O([0, 0, 0]), this) : i(this, new O([255, 255, 255]))).rgb()),
                        new O(e.concat([this._rgb[3]])))
                  : tn.apply(void 0, this._rgb.slice(0, 3));
              }),
              function (e, t, r) {
                return 0.2126 * (e = rn(e)) + 0.7152 * (t = rn(t)) + 0.0722 * (r = rn(r));
              }),
            rn = function (e) {
              return (e /= 255) <= 0.03928 ? e / 12.92 : en((e + 0.055) / 1.055, 2.4);
            },
            o = {},
            nn = s,
            an = e.type,
            N = o,
            u = s,
            on = Yr,
            sn =
              ((u.prototype.mix = u.prototype.interpolate =
                function (e, t) {
                  void 0 === t && (t = 0.5);
                  for (var r = [], n = arguments.length - 2; 0 < n--; ) r[n] = arguments[n + 2];
                  return on.apply(void 0, [this, e, t].concat(r));
                }),
              s),
            ln =
              ((sn.prototype.premultiply = function (e) {
                var t = this._rgb,
                  r = t[3];
                return (e = void 0 === e ? !1 : e)
                  ? ((this._rgb = [t[0] * r, t[1] * r, t[2] * r, r]), this)
                  : new sn([t[0] * r, t[1] * r, t[2] * r, r], 'rgb');
              }),
              s),
            un = c,
            cn =
              ((ln.prototype.saturate = function (e) {
                void 0 === e && (e = 1);
                var t = this.lch();
                return (t[1] += un.Kn * e), t[1] < 0 && (t[1] = 0), new ln(t, 'lch').alpha(this.alpha(), !0);
              }),
              (ln.prototype.desaturate = function (e) {
                return this.saturate(-(e = void 0 === e ? 1 : e));
              }),
              s),
            fn = e.type,
            hn =
              ((cn.prototype.set = function (e, t, r) {
                void 0 === r && (r = !1);
                var e = e.split('.'),
                  n = e[0],
                  e = e[1],
                  a = this[n]();
                if (e) {
                  var o = n.indexOf(e) - ('ok' === n.substr(0, 2) ? 2 : 0);
                  if (-1 < o) {
                    if ('string' == fn(t))
                      switch (t.charAt(0)) {
                        case '+':
                        case '-':
                          a[o] += +t;
                          break;
                        case '*':
                          a[o] *= +t.substr(1);
                          break;
                        case '/':
                          a[o] /= +t.substr(1);
                          break;
                        default:
                          a[o] = +t;
                      }
                    else {
                      if ('number' !== fn(t)) throw new Error('unsupported value for Color.set');
                      a[o] = t;
                    }
                    var s = new cn(a, n);
                    return r ? ((this._rgb = s._rgb), this) : s;
                  }
                  throw new Error('unknown channel ' + e + ' in mode ' + n);
                }
                return a;
              }),
              s),
            pn =
              ((o.rgb = function (e, t, r) {
                (e = e._rgb), (t = t._rgb);
                return new hn(e[0] + r * (t[0] - e[0]), e[1] + r * (t[1] - e[1]), e[2] + r * (t[2] - e[2]), 'rgb');
              }),
              s),
            dn = Math.sqrt,
            R = Math.pow,
            gn =
              ((o.lrgb = function (e, t, r) {
                var e = e._rgb,
                  n = e[0],
                  a = e[1],
                  e = e[2],
                  t = t._rgb,
                  o = t[0],
                  s = t[1],
                  t = t[2];
                return new pn(
                  dn(R(n, 2) * (1 - r) + R(o, 2) * r),
                  dn(R(a, 2) * (1 - r) + R(s, 2) * r),
                  dn(R(e, 2) * (1 - r) + R(t, 2) * r),
                  'rgb',
                );
              }),
              s),
            bn =
              ((o.lab = function (e, t, r) {
                (e = e.lab()), (t = t.lab());
                return new gn(e[0] + r * (t[0] - e[0]), e[1] + r * (t[1] - e[1]), e[2] + r * (t[2] - e[2]), 'lab');
              }),
              s),
            mn = L,
            vn = ((o.lch = Xr), (o.hcl = Xr), s),
            yn =
              ((o.num = function (e, t, r) {
                (e = e.num()), (t = t.num());
                return new vn(e + r * (t - e), 'num');
              }),
              L),
            wn =
              ((o.hcg = function (e, t, r) {
                return yn(e, t, r, 'hcg');
              }),
              L),
            kn =
              ((o.hsi = function (e, t, r) {
                return wn(e, t, r, 'hsi');
              }),
              L),
            xn =
              ((o.hsl = function (e, t, r) {
                return kn(e, t, r, 'hsl');
              }),
              L),
            Sn =
              ((o.hsv = function (e, t, r) {
                return xn(e, t, r, 'hsv');
              }),
              s),
            Ln =
              ((o.oklab = function (e, t, r) {
                (e = e.oklab()), (t = t.oklab());
                return new Sn(e[0] + r * (t[0] - e[0]), e[1] + r * (t[1] - e[1]), e[2] + r * (t[2] - e[2]), 'oklab');
              }),
              L),
            On =
              ((o.oklch = function (e, t, r) {
                return Ln(e, t, r, 'oklch');
              }),
              s),
            Nn = e.clip_rgb,
            Rn = Math.pow,
            Cn = Math.sqrt,
            Pn = Math.PI,
            jn = Math.cos,
            Mn = Math.sin,
            En = Math.atan2,
            C = l,
            P = e.type,
            In = Math.pow;
          for (
            var j = s,
              $n = Zr,
              An = function (e) {
                for (var t = [1, 1], r = 1; r < e; r++) {
                  for (var n = [1], a = 1; a <= t.length; a++) n[a] = (t[a] || 0) + t[a - 1];
                  t = n;
                }
                return t;
              },
              _n = l,
              M = function (e, t, r) {
                if (M[r]) return M[r](e, t);
                throw new Error('unknown blend mode ' + r);
              },
              v = function (r) {
                return function (e, t) {
                  (t = _n(t).rgb()), (e = _n(e).rgb());
                  return _n.rgb(r(t, e));
                };
              },
              u = function (n) {
                return function (e, t) {
                  var r = [];
                  return (r[0] = n(e[0], t[0])), (r[1] = n(e[1], t[1])), (r[2] = n(e[2], t[2])), r;
                };
              },
              c =
                ((M.normal = v(
                  u(function (e) {
                    return e;
                  }),
                )),
                (M.multiply = v(
                  u(function (e, t) {
                    return (e * t) / 255;
                  }),
                )),
                (M.screen = v(
                  u(function (e, t) {
                    return 255 * (1 - (1 - e / 255) * (1 - t / 255));
                  }),
                )),
                (M.overlay = v(
                  u(function (e, t) {
                    return t < 128 ? (2 * e * t) / 255 : 255 * (1 - 2 * (1 - e / 255) * (1 - t / 255));
                  }),
                )),
                (M.darken = v(
                  u(function (e, t) {
                    return t < e ? t : e;
                  }),
                )),
                (M.lighten = v(
                  u(function (e, t) {
                    return t < e ? e : t;
                  }),
                )),
                (M.dodge = v(
                  u(function (e, t) {
                    return 255 === e || 255 < (e = ((t / 255) * 255) / (1 - e / 255)) ? 255 : e;
                  }),
                )),
                (M.burn = v(
                  u(function (e, t) {
                    return 255 * (1 - (1 - t / 255) / (e / 255));
                  }),
                )),
                M),
              Fn = e.type,
              Un = e.clip_rgb,
              Tn = e.TWOPI,
              Dn = Math.pow,
              Vn = Math.sin,
              Bn = Math.cos,
              qn = l,
              zn = s,
              Kn = Math.floor,
              Hn = Math.random,
              Jn = r,
              Wn = Math.log,
              Gn = Math.pow,
              Yn = Math.floor,
              Xn = Math.abs,
              Zn = function (e, t) {
                void 0 === t && (t = null);
                var r = { min: Number.MAX_VALUE, max: -1 * Number.MAX_VALUE, sum: 0, values: [], count: 0 };
                return (
                  (e = 'object' === Jn(e) ? Object.values(e) : e).forEach(function (e) {
                    null == (e = t && 'object' === Jn(e) ? e[t] : e) ||
                      isNaN(e) ||
                      (r.values.push(e),
                      (r.sum += e),
                      e < r.min && (r.min = e),
                      r.max < e && (r.max = e),
                      (r.count += 1));
                  }),
                  (r.domain = [r.min, r.max]),
                  (r.limits = function (e, t) {
                    return Qn(r, e, t);
                  }),
                  r
                );
              },
              Qn = function (e, t, r) {
                void 0 === t && (t = 'equal'), void 0 === r && (r = 7);
                var n = (e = 'array' == Jn(e) ? Zn(e) : e).min,
                  a = e.max,
                  o = e.values.sort(function (e, t) {
                    return e - t;
                  });
                if (1 === r) return [n, a];
                var s = [];
                if (('c' === t.substr(0, 1) && (s.push(n), s.push(a)), 'e' === t.substr(0, 1))) {
                  s.push(n);
                  for (var i = 1; i < r; i++) s.push(n + (i / r) * (a - n));
                  s.push(a);
                } else if ('l' === t.substr(0, 1)) {
                  if (n <= 0) throw new Error('Logarithmic scales are only possible for values > 0');
                  var l = Math.LOG10E * Wn(n),
                    _ = Math.LOG10E * Wn(a);
                  s.push(n);
                  for (var u = 1; u < r; u++) s.push(Gn(10, l + (u / r) * (_ - l)));
                  s.push(a);
                } else if ('q' === t.substr(0, 1)) {
                  s.push(n);
                  for (var c = 1; c < r; c++) {
                    var f = ((o.length - 1) * c) / r,
                      h = Yn(f);
                    s.push(h === f ? o[h] : o[h] * (1 - (f = f - h)) + o[h + 1] * f);
                  }
                  s.push(a);
                } else if ('k' === t.substr(0, 1)) {
                  var p,
                    d = o.length,
                    g = new Array(d),
                    b = new Array(r),
                    m = !0,
                    F = 0,
                    v = null;
                  (v = []).push(n);
                  for (var y = 1; y < r; y++) v.push(n + (y / r) * (a - n));
                  for (v.push(a); m; ) {
                    for (var w = 0; w < r; w++) b[w] = 0;
                    for (var k = 0; k < d; k++)
                      for (var U = o[k], T = Number.MAX_VALUE, x = void 0, S = 0; S < r; S++) {
                        var D = Xn(v[S] - U);
                        D < T && ((T = D), (x = S)), b[x]++, (g[k] = x);
                      }
                    for (var L = new Array(r), O = 0; O < r; O++) L[O] = null;
                    for (var N = 0; N < d; N++) null === L[(p = g[N])] ? (L[p] = o[N]) : (L[p] += o[N]);
                    for (var R = 0; R < r; R++) L[R] *= 1 / b[R];
                    for (var m = !1, C = 0; C < r; C++)
                      if (L[C] !== v[C]) {
                        m = !0;
                        break;
                      }
                    (v = L), 200 < ++F && (m = !1);
                  }
                  for (var P = {}, j = 0; j < r; j++) P[j] = [];
                  for (var M = 0; M < d; M++) P[(p = g[M])].push(o[M]);
                  for (var E = [], I = 0; I < r; I++) E.push(P[I][0]), E.push(P[I][P[I].length - 1]);
                  (E = E.sort(function (e, t) {
                    return e - t;
                  })),
                    s.push(E[0]);
                  for (var $ = 1; $ < E.length; $ += 2) {
                    var A = E[$];
                    isNaN(A) || -1 !== s.indexOf(A) || s.push(A);
                  }
                }
                return s;
              },
              o = Zn,
              v = Qn,
              ea = s,
              ta = s,
              E = Math.sqrt,
              I = Math.pow,
              ra = Math.min,
              na = Math.max,
              aa = Math.atan2,
              oa = Math.abs,
              $ = Math.cos,
              sa = Math.sin,
              ia = Math.exp,
              la = Math.PI,
              ua = s,
              ca = s,
              fa = l,
              ha = Zr,
              u = {
                cool: function () {
                  return ha([fa.hsl(180, 1, 0.9), fa.hsl(250, 0.7, 0.4)]);
                },
                hot: function () {
                  return ha(['#000', '#f00', '#ff0', '#fff']).mode('rgb');
                },
              },
              A = {
                OrRd: [
                  '#fff7ec',
                  '#fee8c8',
                  '#fdd49e',
                  '#fdbb84',
                  '#fc8d59',
                  '#ef6548',
                  '#d7301f',
                  '#b30000',
                  '#7f0000',
                ],
                PuBu: [
                  '#fff7fb',
                  '#ece7f2',
                  '#d0d1e6',
                  '#a6bddb',
                  '#74a9cf',
                  '#3690c0',
                  '#0570b0',
                  '#045a8d',
                  '#023858',
                ],
                BuPu: [
                  '#f7fcfd',
                  '#e0ecf4',
                  '#bfd3e6',
                  '#9ebcda',
                  '#8c96c6',
                  '#8c6bb1',
                  '#88419d',
                  '#810f7c',
                  '#4d004b',
                ],
                Oranges: [
                  '#fff5eb',
                  '#fee6ce',
                  '#fdd0a2',
                  '#fdae6b',
                  '#fd8d3c',
                  '#f16913',
                  '#d94801',
                  '#a63603',
                  '#7f2704',
                ],
                BuGn: [
                  '#f7fcfd',
                  '#e5f5f9',
                  '#ccece6',
                  '#99d8c9',
                  '#66c2a4',
                  '#41ae76',
                  '#238b45',
                  '#006d2c',
                  '#00441b',
                ],
                YlOrBr: [
                  '#ffffe5',
                  '#fff7bc',
                  '#fee391',
                  '#fec44f',
                  '#fe9929',
                  '#ec7014',
                  '#cc4c02',
                  '#993404',
                  '#662506',
                ],
                YlGn: [
                  '#ffffe5',
                  '#f7fcb9',
                  '#d9f0a3',
                  '#addd8e',
                  '#78c679',
                  '#41ab5d',
                  '#238443',
                  '#006837',
                  '#004529',
                ],
                Reds: [
                  '#fff5f0',
                  '#fee0d2',
                  '#fcbba1',
                  '#fc9272',
                  '#fb6a4a',
                  '#ef3b2c',
                  '#cb181d',
                  '#a50f15',
                  '#67000d',
                ],
                RdPu: [
                  '#fff7f3',
                  '#fde0dd',
                  '#fcc5c0',
                  '#fa9fb5',
                  '#f768a1',
                  '#dd3497',
                  '#ae017e',
                  '#7a0177',
                  '#49006a',
                ],
                Greens: [
                  '#f7fcf5',
                  '#e5f5e0',
                  '#c7e9c0',
                  '#a1d99b',
                  '#74c476',
                  '#41ab5d',
                  '#238b45',
                  '#006d2c',
                  '#00441b',
                ],
                YlGnBu: [
                  '#ffffd9',
                  '#edf8b1',
                  '#c7e9b4',
                  '#7fcdbb',
                  '#41b6c4',
                  '#1d91c0',
                  '#225ea8',
                  '#253494',
                  '#081d58',
                ],
                Purples: [
                  '#fcfbfd',
                  '#efedf5',
                  '#dadaeb',
                  '#bcbddc',
                  '#9e9ac8',
                  '#807dba',
                  '#6a51a3',
                  '#54278f',
                  '#3f007d',
                ],
                GnBu: [
                  '#f7fcf0',
                  '#e0f3db',
                  '#ccebc5',
                  '#a8ddb5',
                  '#7bccc4',
                  '#4eb3d3',
                  '#2b8cbe',
                  '#0868ac',
                  '#084081',
                ],
                Greys: [
                  '#ffffff',
                  '#f0f0f0',
                  '#d9d9d9',
                  '#bdbdbd',
                  '#969696',
                  '#737373',
                  '#525252',
                  '#252525',
                  '#000000',
                ],
                YlOrRd: [
                  '#ffffcc',
                  '#ffeda0',
                  '#fed976',
                  '#feb24c',
                  '#fd8d3c',
                  '#fc4e2a',
                  '#e31a1c',
                  '#bd0026',
                  '#800026',
                ],
                PuRd: [
                  '#f7f4f9',
                  '#e7e1ef',
                  '#d4b9da',
                  '#c994c7',
                  '#df65b0',
                  '#e7298a',
                  '#ce1256',
                  '#980043',
                  '#67001f',
                ],
                Blues: [
                  '#f7fbff',
                  '#deebf7',
                  '#c6dbef',
                  '#9ecae1',
                  '#6baed6',
                  '#4292c6',
                  '#2171b5',
                  '#08519c',
                  '#08306b',
                ],
                PuBuGn: [
                  '#fff7fb',
                  '#ece2f0',
                  '#d0d1e6',
                  '#a6bddb',
                  '#67a9cf',
                  '#3690c0',
                  '#02818a',
                  '#016c59',
                  '#014636',
                ],
                Viridis: [
                  '#440154',
                  '#482777',
                  '#3f4a8a',
                  '#31678e',
                  '#26838f',
                  '#1f9d8a',
                  '#6cce5a',
                  '#b6de2b',
                  '#fee825',
                ],
                Spectral: [
                  '#9e0142',
                  '#d53e4f',
                  '#f46d43',
                  '#fdae61',
                  '#fee08b',
                  '#ffffbf',
                  '#e6f598',
                  '#abdda4',
                  '#66c2a5',
                  '#3288bd',
                  '#5e4fa2',
                ],
                RdYlGn: [
                  '#a50026',
                  '#d73027',
                  '#f46d43',
                  '#fdae61',
                  '#fee08b',
                  '#ffffbf',
                  '#d9ef8b',
                  '#a6d96a',
                  '#66bd63',
                  '#1a9850',
                  '#006837',
                ],
                RdBu: [
                  '#67001f',
                  '#b2182b',
                  '#d6604d',
                  '#f4a582',
                  '#fddbc7',
                  '#f7f7f7',
                  '#d1e5f0',
                  '#92c5de',
                  '#4393c3',
                  '#2166ac',
                  '#053061',
                ],
                PiYG: [
                  '#8e0152',
                  '#c51b7d',
                  '#de77ae',
                  '#f1b6da',
                  '#fde0ef',
                  '#f7f7f7',
                  '#e6f5d0',
                  '#b8e186',
                  '#7fbc41',
                  '#4d9221',
                  '#276419',
                ],
                PRGn: [
                  '#40004b',
                  '#762a83',
                  '#9970ab',
                  '#c2a5cf',
                  '#e7d4e8',
                  '#f7f7f7',
                  '#d9f0d3',
                  '#a6dba0',
                  '#5aae61',
                  '#1b7837',
                  '#00441b',
                ],
                RdYlBu: [
                  '#a50026',
                  '#d73027',
                  '#f46d43',
                  '#fdae61',
                  '#fee090',
                  '#ffffbf',
                  '#e0f3f8',
                  '#abd9e9',
                  '#74add1',
                  '#4575b4',
                  '#313695',
                ],
                BrBG: [
                  '#543005',
                  '#8c510a',
                  '#bf812d',
                  '#dfc27d',
                  '#f6e8c3',
                  '#f5f5f5',
                  '#c7eae5',
                  '#80cdc1',
                  '#35978f',
                  '#01665e',
                  '#003c30',
                ],
                RdGy: [
                  '#67001f',
                  '#b2182b',
                  '#d6604d',
                  '#f4a582',
                  '#fddbc7',
                  '#ffffff',
                  '#e0e0e0',
                  '#bababa',
                  '#878787',
                  '#4d4d4d',
                  '#1a1a1a',
                ],
                PuOr: [
                  '#7f3b08',
                  '#b35806',
                  '#e08214',
                  '#fdb863',
                  '#fee0b6',
                  '#f7f7f7',
                  '#d8daeb',
                  '#b2abd2',
                  '#8073ac',
                  '#542788',
                  '#2d004b',
                ],
                Set2: ['#66c2a5', '#fc8d62', '#8da0cb', '#e78ac3', '#a6d854', '#ffd92f', '#e5c494', '#b3b3b3'],
                Accent: ['#7fc97f', '#beaed4', '#fdc086', '#ffff99', '#386cb0', '#f0027f', '#bf5b17', '#666666'],
                Set1: [
                  '#e41a1c',
                  '#377eb8',
                  '#4daf4a',
                  '#984ea3',
                  '#ff7f00',
                  '#ffff33',
                  '#a65628',
                  '#f781bf',
                  '#999999',
                ],
                Set3: [
                  '#8dd3c7',
                  '#ffffb3',
                  '#bebada',
                  '#fb8072',
                  '#80b1d3',
                  '#fdb462',
                  '#b3de69',
                  '#fccde5',
                  '#d9d9d9',
                  '#bc80bd',
                  '#ccebc5',
                  '#ffed6f',
                ],
                Dark2: ['#1b9e77', '#d95f02', '#7570b3', '#e7298a', '#66a61e', '#e6ab02', '#a6761d', '#666666'],
                Paired: [
                  '#a6cee3',
                  '#1f78b4',
                  '#b2df8a',
                  '#33a02c',
                  '#fb9a99',
                  '#e31a1c',
                  '#fdbf6f',
                  '#ff7f00',
                  '#cab2d6',
                  '#6a3d9a',
                  '#ffff99',
                  '#b15928',
                ],
                Pastel2: ['#b3e2cd', '#fdcdac', '#cbd5e8', '#f4cae4', '#e6f5c9', '#fff2ae', '#f1e2cc', '#cccccc'],
                Pastel1: [
                  '#fbb4ae',
                  '#b3cde3',
                  '#ccebc5',
                  '#decbe4',
                  '#fed9a6',
                  '#ffffcc',
                  '#e5d8bd',
                  '#fddaec',
                  '#f2f2f2',
                ],
              },
              pa = 0,
              da = Object.keys(A);
            pa < da.length;
            pa += 1
          ) {
            var ga = da[pa];
            A[ga.toLowerCase()] = A[ga];
          }
          (e = A), (s = l);
          return (
            (s.average = function (e, o, s) {
              void 0 === o && (o = 'lrgb'), void 0 === s && (s = null);
              var t = e.length,
                r =
                  t /
                  (s =
                    s ||
                    Array.from(new Array(t)).map(function () {
                      return 1;
                    })).reduce(function (e, t) {
                    return e + t;
                  });
              if (
                (s.forEach(function (e, t) {
                  s[t] *= r;
                }),
                (e = e.map(function (e) {
                  return new On(e);
                })),
                'lrgb' === o)
              ) {
                for (var n = e, a = s, i = n.length, l = [0, 0, 0, 0], u = 0; u < n.length; u++) {
                  var c = n[u];
                  var f = a[u] / i;
                  c = c._rgb;
                  l[0] += Rn(c[0], 2) * f;
                  l[1] += Rn(c[1], 2) * f;
                  l[2] += Rn(c[2], 2) * f;
                  l[3] += c[3] * f;
                }
                if (((l[0] = Cn(l[0])), (l[1] = Cn(l[1])), (l[2] = Cn(l[2])), l[3] > 0.9999999)) l[3] = 1;
                return new On(Nn(l));
              }
              for (var h, p = e.shift(), d = p.get(o), g = [], b = 0, m = 0, v = 0; v < d.length; v++)
                (d[v] = (d[v] || 0) * s[0]),
                  g.push(isNaN(d[v]) ? 0 : s[0]),
                  'h' !== o.charAt(v) ||
                    isNaN(d[v]) ||
                    ((h = (d[v] / 180) * Pn), (b += jn(h) * s[0]), (m += Mn(h) * s[0]));
              var y = p.alpha() * s[0];
              e.forEach(function (e, t) {
                var r = e.get(o);
                y += e.alpha() * s[t + 1];
                for (var n, a = 0; a < d.length; a++)
                  isNaN(r[a]) ||
                    ((g[a] += s[t + 1]),
                    'h' === o.charAt(a)
                      ? ((n = (r[a] / 180) * Pn), (b += jn(n) * s[t + 1]), (m += Mn(n) * s[t + 1]))
                      : (d[a] += r[a] * s[t + 1]));
              });
              for (var w = 0; w < d.length; w++)
                if ('h' === o.charAt(w)) {
                  for (var k = (En(m / g[w], b / g[w]) / Pn) * 180; k < 0; ) k += 360;
                  for (; 360 <= k; ) k -= 360;
                  d[w] = k;
                } else d[w] = d[w] / g[w];
              return (y /= t), new On(d, o).alpha(0.99999 < y ? 1 : y, !0);
            }),
            (s.bezier = function (e) {
              var t = (function (e) {
                if (
                  2 ===
                  (e = e.map(function (e) {
                    return new j(e);
                  })).length
                )
                  (s = e.map(function (e) {
                    return e.lab();
                  })),
                    (r = s[0]),
                    (n = s[1]),
                    (s = function (t) {
                      var e = [0, 1, 2].map(function (e) {
                        return r[e] + t * (n[e] - r[e]);
                      });
                      return new j(e, 'lab');
                    });
                else if (3 === e.length)
                  (t = e.map(function (e) {
                    return e.lab();
                  })),
                    (r = t[0]),
                    (n = t[1]),
                    (a = t[2]),
                    (s = function (t) {
                      var e = [0, 1, 2].map(function (e) {
                        return (1 - t) * (1 - t) * r[e] + 2 * (1 - t) * t * n[e] + t * t * a[e];
                      });
                      return new j(e, 'lab');
                    });
                else if (4 === e.length)
                  var t,
                    r = (t = e.map(function (e) {
                      return e.lab();
                    }))[0],
                    n = t[1],
                    a = t[2],
                    o = t[3],
                    s = function (t) {
                      var e = [0, 1, 2].map(function (e) {
                        return (
                          (1 - t) * (1 - t) * (1 - t) * r[e] +
                          3 * (1 - t) * (1 - t) * t * n[e] +
                          3 * (1 - t) * t * t * a[e] +
                          t * t * t * o[e]
                        );
                      });
                      return new j(e, 'lab');
                    };
                else {
                  if (!(5 <= e.length)) throw new RangeError('No point in running bezier with only one color.');
                  var i = e.map(function (e) {
                      return e.lab();
                    }),
                    l = e.length - 1,
                    u = An(l);
                  s = function (a) {
                    var o = 1 - a,
                      e = [0, 1, 2].map(function (n) {
                        return i.reduce(function (e, t, r) {
                          return e + u[r] * Math.pow(o, l - r) * Math.pow(a, r) * t[n];
                        }, 0);
                      });
                    return new j(e, 'lab');
                  };
                }
                return s;
              })(e);
              return (
                (t.scale = function () {
                  return $n(t);
                }),
                t
              );
            }),
            (s.blend = c),
            (s.cubehelix = function (a, o, s, i, l) {
              void 0 === a && (a = 300), void 0 === o && (o = -1.5), void 0 === s && (s = 1), void 0 === i && (i = 1);
              function t(e) {
                var t = Tn * ((a + 120) / 360 + o * e),
                  r = Dn(l[0] + u * e, i),
                  e = ((0 !== c ? s[0] + e * c : s) * r * (1 - r)) / 2,
                  n = Bn(t),
                  t = Vn(t);
                return qn(
                  Un([
                    255 * (r + e * (-0.14861 * n + 1.78277 * t)),
                    255 * (r + e * (-0.29227 * n - 0.90649 * t)),
                    255 * (r + 1.97294 * n * e),
                    1,
                  ]),
                );
              }
              var u,
                c = 0;
              'array' === Fn((l = void 0 === l ? [0, 1] : l)) ? (u = l[1] - l[0]) : ((u = 0), (l = [l, l]));
              return (
                (t.start = function (e) {
                  return null == e ? a : ((a = e), t);
                }),
                (t.rotations = function (e) {
                  return null == e ? o : ((o = e), t);
                }),
                (t.gamma = function (e) {
                  return null == e ? i : ((i = e), t);
                }),
                (t.hue = function (e) {
                  return null == e ? s : ('array' === Fn((s = e)) ? 0 === (c = s[1] - s[0]) && (s = s[1]) : (c = 0), t);
                }),
                (t.lightness = function (e) {
                  return null == e ? l : ((u = 'array' === Fn(e) ? (l = e)[1] - e[0] : ((l = [e, e]), 0)), t);
                }),
                (t.scale = function () {
                  return qn.scale(t);
                }),
                t.hue(s),
                t
              );
            }),
            (s.mix = s.interpolate = Yr),
            (s.random = function () {
              for (var e = '#', t = 0; t < 6; t++) e += '0123456789abcdef'.charAt(Kn(16 * Hn()));
              return new zn(e, 'hex');
            }),
            (s.scale = Zr),
            (s.analyze = o),
            (s.contrast = function (e, t) {
              (e = new ea(e)), (t = new ea(t));
              (e = e.luminance()), (t = t.luminance());
              return t < e ? (e + 0.05) / (t + 0.05) : (t + 0.05) / (e + 0.05);
            }),
            (s.deltaE = function (e, t, r, n, a) {
              void 0 === r && (r = 1), void 0 === n && (n = 1), void 0 === a && (a = 1);
              function o(e) {
                return (360 * e) / (2 * la);
              }
              function s(e) {
                return (2 * la * e) / 360;
              }
              (e = new ta(e)), (t = new ta(t));
              var e = Array.from(e.lab()),
                i = e[0],
                l = e[1],
                e = e[2],
                t = Array.from(t.lab()),
                u = t[0],
                c = t[1],
                t = t[2],
                f = (i + u) / 2,
                h = (E(I(l, 2) + I(e, 2)) + E(I(c, 2) + I(t, 2))) / 2,
                h = 0.5 * (1 - E(I(h, 7) / (I(h, 7) + I(25, 7)))),
                l = l * (1 + h),
                c = c * (1 + h),
                h = E(I(l, 2) + I(e, 2)),
                p = E(I(c, 2) + I(t, 2)),
                d = (h + p) / 2,
                e = o(aa(e, l)),
                l = o(aa(t, c)),
                t = 0 <= e ? e : e + 360,
                c = 0 <= l ? l : l + 360,
                e = 180 < oa(t - c) ? (t + c + 360) / 2 : (t + c) / 2,
                l = 1 - 0.17 * $(s(e - 30)) + 0.24 * $(s(2 * e)) + 0.32 * $(s(3 * e + 6)) - 0.2 * $(s(4 * e - 63)),
                g = oa((g = c - t)) <= 180 ? g : c <= t ? 360 + g : g - 360,
                c = ((g = 2 * E(h * p) * sa(s(g) / 2)), u - i),
                t = p - h,
                u = 1 + (0.015 * I(f - 50, 2)) / E(20 + I(f - 50, 2)),
                i = 1 + 0.045 * d,
                p = 1 + 0.015 * d * l,
                h = 30 * ia(-I((e - 275) / 25, 2)),
                f = -(2 * E(I(d, 7) / (I(d, 7) + I(25, 7)))) * sa(2 * s(h)),
                l = E(I(c / (r * u), 2) + I(t / (n * i), 2) + I(g / (a * p), 2) + (t / (n * i)) * f * (g / (a * p)));
              return na(0, ra(100, l));
            }),
            (s.distance = function (e, t, r) {
              void 0 === r && (r = 'lab'), (e = new ua(e)), (t = new ua(t));
              var n,
                a = e.get(r),
                o = t.get(r),
                s = 0;
              for (n in a) {
                var i = (a[n] || 0) - (o[n] || 0);
                s += i * i;
              }
              return Math.sqrt(s);
            }),
            (s.limits = v),
            (s.valid = function () {
              for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
              try {
                return new (Function.prototype.bind.apply(ca, [null].concat(e)))(), !0;
              } catch (e) {
                return !1;
              }
            }),
            (s.scales = u),
            (s.colors = b),
            (s.brewer = e),
            s
          );
        }),
          'object' == typeof (e = e) && void 0 !== t
            ? (t.exports = r())
            : 'function' == typeof define && define.amd
              ? define(r)
              : ((e = 'undefined' != typeof globalThis ? globalThis : e || self).chroma = r());
      },
    }),
    (T = function () {
      return t || (0, e[u(e)[0]])((t = { exports: {} }).exports, t), t.exports;
    }),
    (D = {
      type: 'logger',
      log(e) {
        this.output('log', e);
      },
      warn(e) {
        this.output('warn', e);
      },
      error(e) {
        this.output('error', e);
      },
      output(e, t) {
        console && console[e] && console[e].apply(console, t);
      },
    }),
    (c = new (r = class {
      constructor(e) {
        this.init(e, 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : {});
      }
      init(e) {
        var t = 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : {};
        (this.prefix = t.prefix || 'i18next:'), (this.logger = e || D), (this.options = t), (this.debug = t.debug);
      }
      log() {
        for (var e = arguments.length, t = new Array(e), r = 0; r < e; r++) t[r] = arguments[r];
        return this.forward(t, 'log', '', !0);
      }
      warn() {
        for (var e = arguments.length, t = new Array(e), r = 0; r < e; r++) t[r] = arguments[r];
        return this.forward(t, 'warn', '', !0);
      }
      error() {
        for (var e = arguments.length, t = new Array(e), r = 0; r < e; r++) t[r] = arguments[r];
        return this.forward(t, 'error', '');
      }
      deprecate() {
        for (var e = arguments.length, t = new Array(e), r = 0; r < e; r++) t[r] = arguments[r];
        return this.forward(t, 'warn', 'WARNING DEPRECATED: ', !0);
      }
      forward(e, t, r, n) {
        return n && !this.debug
          ? null
          : ('string' == typeof e[0] && (e[0] = '' + r + this.prefix + ' ' + e[0]), this.logger[t](e));
      }
      create(e) {
        return new r(this.logger, { prefix: this.prefix + `:${e}:`, ...this.options });
      }
      clone(e) {
        return ((e = e || this.options).prefix = e.prefix || this.prefix), new r(this.logger, e);
      }
    })()),
    (n = class {
      constructor() {
        this.observers = {};
      }
      on(e, r) {
        return (
          e.split(' ').forEach((e) => {
            this.observers[e] || (this.observers[e] = new Map());
            var t = this.observers[e].get(r) || 0;
            this.observers[e].set(r, t + 1);
          }),
          this
        );
      }
      off(e, t) {
        this.observers[e] && (t ? this.observers[e].delete(t) : delete this.observers[e]);
      }
      emit(n) {
        for (var e = arguments.length, a = new Array(1 < e ? e - 1 : 0), t = 1; t < e; t++) a[t - 1] = arguments[t];
        this.observers[n] &&
          Array.from(this.observers[n].entries()).forEach((e) => {
            var [t, r] = e;
            for (let e = 0; e < r; e++) t(...a);
          }),
          this.observers['*'] &&
            Array.from(this.observers['*'].entries()).forEach((e) => {
              var [t, r] = e;
              for (let e = 0; e < r; e++) t.apply(t, [n, ...a]);
            });
      }
    }),
    (V = /###/g),
    (B = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;', '/': '&#x2F;' }),
    (q = [' ', ',', '?', '!', ';']),
    (z = new (class {
      constructor(e) {
        (this.capacity = e), (this.regExpMap = new Map()), (this.regExpQueue = []);
      }
      getRegExp(e) {
        var t = this.regExpMap.get(e);
        return (
          void 0 !== t ||
            ((t = new RegExp(e)),
            this.regExpQueue.length === this.capacity && this.regExpMap.delete(this.regExpQueue.shift()),
            this.regExpMap.set(e, t),
            this.regExpQueue.push(e)),
          t
        );
      }
    })(20)),
    (f = class extends n {
      constructor(e) {
        var t =
          1 < arguments.length && void 0 !== arguments[1]
            ? arguments[1]
            : { ns: ['translation'], defaultNS: 'translation' };
        super(),
          (this.data = e || {}),
          (this.options = t),
          void 0 === this.options.keySeparator && (this.options.keySeparator = '.'),
          void 0 === this.options.ignoreJSONStructure && (this.options.ignoreJSONStructure = !0);
      }
      addNamespaces(e) {
        this.options.ns.indexOf(e) < 0 && this.options.ns.push(e);
      }
      removeNamespaces(e) {
        e = this.options.ns.indexOf(e);
        -1 < e && this.options.ns.splice(e, 1);
      }
      getResource(e, t, r) {
        var n = 3 < arguments.length && void 0 !== arguments[3] ? arguments[3] : {},
          a = (void 0 !== n.keySeparator ? n : this.options).keySeparator,
          n = (void 0 !== n.ignoreJSONStructure ? n : this.options).ignoreJSONStructure;
        let o;
        -1 < e.indexOf('.')
          ? (o = e.split('.'))
          : ((o = [e, t]),
            r && (Array.isArray(r) ? o.push(...r) : 'string' == typeof r && a ? o.push(...r.split(a)) : o.push(r)));
        var s = N(this.data, o);
        return (
          !s && !t && !r && -1 < e.indexOf('.') && ((e = o[0]), (t = o[1]), (r = o.slice(2).join('.'))),
          s || !n || 'string' != typeof r ? s : P(this.data && this.data[e] && this.data[e][t], r, a)
        );
      }
      addResource(e, t, r, n) {
        var a = 4 < arguments.length && void 0 !== arguments[4] ? arguments[4] : { silent: !1 },
          o = (void 0 !== a.keySeparator ? a : this.options).keySeparator;
        let s = [e, t];
        r && (s = s.concat(o ? r.split(o) : r)),
          -1 < e.indexOf('.') && ((n = t), (t = (s = e.split('.'))[1])),
          this.addNamespaces(t),
          ue(this.data, s, n),
          a.silent || this.emit('added', e, t, r, n);
      }
      addResources(e, t, r) {
        var n = 3 < arguments.length && void 0 !== arguments[3] ? arguments[3] : { silent: !1 };
        for (const a in r)
          ('string' != typeof r[a] && '[object Array]' !== Object.prototype.toString.apply(r[a])) ||
            this.addResource(e, t, a, r[a], { silent: !0 });
        n.silent || this.emit('added', e, t, r);
      }
      addResourceBundle(e, t, r, n, a) {
        var o = 5 < arguments.length && void 0 !== arguments[5] ? arguments[5] : { silent: !1, skipCopy: !1 };
        let s = [e, t],
          i =
            (-1 < e.indexOf('.') && ((n = r), (r = t), (t = (s = e.split('.'))[1])),
            this.addNamespaces(t),
            N(this.data, s) || {});
        o.skipCopy || (r = JSON.parse(JSON.stringify(r))),
          n ? fe(i, r, a) : (i = { ...i, ...r }),
          ue(this.data, s, i),
          o.silent || this.emit('added', e, t, r);
      }
      removeResourceBundle(e, t) {
        this.hasResourceBundle(e, t) && delete this.data[e][t], this.removeNamespaces(t), this.emit('removed', e, t);
      }
      hasResourceBundle(e, t) {
        return void 0 !== this.getResource(e, t);
      }
      getResourceBundle(e, t) {
        return (
          (t = t || this.options.defaultNS),
          'v1' === this.options.compatibilityAPI ? { ...this.getResource(e, t) } : this.getResource(e, t)
        );
      }
      getDataByLanguage(e) {
        return this.data[e];
      }
      hasLanguageSomeTranslations(e) {
        const t = this.getDataByLanguage(e);
        return !!((t && Object.keys(t)) || []).find((e) => t[e] && 0 < Object.keys(t[e]).length);
      }
      toJSON() {
        return this.data;
      }
    }),
    (h = {
      processors: {},
      addPostProcessor(e) {
        this.processors[e.name] = e;
      },
      handle(e, t, r, n, a) {
        return (
          e.forEach((e) => {
            this.processors[e] && (t = this.processors[e].process(t, r, n, a));
          }),
          t
        );
      },
    }),
    (o = {}),
    (C = class extends n {
      constructor(e) {
        var t = 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : {};
        super(),
          le(
            [
              'resourceStore',
              'languageUtils',
              'pluralResolver',
              'interpolator',
              'backendConnector',
              'i18nFormat',
              'utils',
            ],
            e,
            this,
          ),
          (this.options = t),
          void 0 === this.options.keySeparator && (this.options.keySeparator = '.'),
          (this.logger = c.create('translator'));
      }
      changeLanguage(e) {
        e && (this.language = e);
      }
      exists(e) {
        return (
          null != e &&
          (e = this.resolve(
            e,
            1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : { interpolation: {} },
          )) &&
          void 0 !== e.res
        );
      }
      extractFromKey(e, t) {
        let r = (void 0 !== t.nsSeparator ? t : this.options).nsSeparator;
        void 0 === r && (r = ':');
        var n = (void 0 !== t.keySeparator ? t : this.options).keySeparator;
        let a = t.ns || this.options.defaultNS || [];
        var o = r && -1 < e.indexOf(r),
          t = !(
            this.options.userDefinedKeySeparator ||
            t.keySeparator ||
            this.options.userDefinedNsSeparator ||
            t.nsSeparator ||
            pe(e, r, n)
          );
        if (o && !t) {
          o = e.match(this.interpolator.nestingRegexp);
          if (o && 0 < o.length) return { key: e, namespaces: a };
          t = e.split(r);
          (r !== n || (r === n && -1 < this.options.ns.indexOf(t[0]))) && (a = t.shift()), (e = t.join(n));
        }
        return { key: e, namespaces: (a = 'string' == typeof a ? [a] : a) };
      }
      translate(r, n, a) {
        if (
          ((n =
            (n =
              'object' ==
              typeof (n =
                'object' != typeof n && this.options.overloadTranslationOptionHandler
                  ? this.options.overloadTranslationOptionHandler(arguments)
                  : n)
                ? { ...n }
                : n) || {}),
          null == r)
        )
          return '';
        Array.isArray(r) || (r = [String(r)]);
        var e = (void 0 !== n.returnDetails ? n : this.options).returnDetails,
          o = (void 0 !== n.keySeparator ? n : this.options).keySeparator;
        const { key: s, namespaces: t } = this.extractFromKey(r[r.length - 1], n),
          i = t[t.length - 1];
        var l = n.lng || this.language,
          u = n.appendNamespaceToCIMode || this.options.appendNamespaceToCIMode;
        if (l && 'cimode' === l.toLowerCase())
          return u
            ? ((u = n.nsSeparator || this.options.nsSeparator),
              e
                ? {
                    res: '' + i + u + s,
                    usedKey: s,
                    exactUsedKey: s,
                    usedLng: l,
                    usedNS: i,
                    usedParams: this.getUsedParamsDetails(n),
                  }
                : '' + i + u + s)
            : e
              ? { res: s, usedKey: s, exactUsedKey: s, usedLng: l, usedNS: i, usedParams: this.getUsedParamsDetails(n) }
              : s;
        u = this.resolve(r, n);
        let c = u && u.res;
        var f = (u && u.usedKey) || s,
          h = (u && u.exactUsedKey) || s,
          p = Object.prototype.toString.apply(c),
          d = (void 0 !== n.joinArrays ? n : this.options).joinArrays,
          g = !this.i18nFormat || this.i18nFormat.handleAsObject,
          b = 'string' != typeof c && 'boolean' != typeof c && 'number' != typeof c;
        if (
          g &&
          c &&
          b &&
          ['[object Number]', '[object Function]', '[object RegExp]'].indexOf(p) < 0 &&
          ('string' != typeof d || '[object Array]' !== p)
        ) {
          if (!n.returnObjects && !this.options.returnObjects)
            return (
              this.options.returnedObjectHandler ||
                this.logger.warn('accessing an object - but returnObjects options is not enabled!'),
              (b = this.options.returnedObjectHandler
                ? this.options.returnedObjectHandler(f, c, { ...n, ns: t })
                : `key '${s} (${this.language})' returned an object instead of string.`),
              e ? ((u.res = b), (u.usedParams = this.getUsedParamsDetails(n)), u) : b
            );
          if (o) {
            var m,
              b = '[object Array]' === p,
              v = b ? [] : {},
              y = b ? h : f;
            for (const k in c)
              Object.prototype.hasOwnProperty.call(c, k) &&
                ((m = '' + y + o + k), (v[k] = this.translate(m, { ...n, joinArrays: !1, ns: t })), v[k] === m) &&
                (v[k] = c[k]);
            c = v;
          }
        } else if (g && 'string' == typeof d && '[object Array]' === p)
          c = (c = c.join(d)) && this.extendTranslation(c, r, n, a);
        else {
          let e = !1,
            t = !1;
          b = void 0 !== n.count && 'string' != typeof n.count;
          const x = C.hasDefaultValue(n);
          (h = b ? this.pluralResolver.getSuffix(l, n.count, n) : ''),
            (f = n.ordinal && b ? this.pluralResolver.getSuffix(l, n.count, { ordinal: !1 }) : '');
          const S = b && !n.ordinal && 0 === n.count && this.pluralResolver.shouldUseIntlApi(),
            L =
              (S && n[`defaultValue${this.options.pluralSeparator}zero`]) ||
              n['defaultValue' + h] ||
              n['defaultValue' + f] ||
              n.defaultValue,
            O =
              (!this.isValidLookup(c) && x && ((e = !0), (c = L)),
              this.isValidLookup(c) || ((t = !0), (c = s)),
              (n.missingKeyNoValueFallbackToKey || this.options.missingKeyNoValueFallbackToKey) && t ? void 0 : c),
            N = x && L !== c && this.options.updateMissing;
          if (t || e || N) {
            this.logger.log(N ? 'updateKey' : 'missingKey', l, i, s, N ? L : c),
              o &&
                (g = this.resolve(s, { ...n, keySeparator: !1 })) &&
                g.res &&
                this.logger.warn(
                  'Seems the loaded translations were in flat JSON format instead of nested. Either set keySeparator: false on init or make sure your translations are published in nested format.',
                );
            let t = [];
            var w = this.languageUtils.getFallbackCodes(this.options.fallbackLng, n.lng || this.language);
            if ('fallback' === this.options.saveMissingTo && w && w[0]) for (let e = 0; e < w.length; e++) t.push(w[e]);
            else
              'all' === this.options.saveMissingTo
                ? (t = this.languageUtils.toResolveHierarchy(n.lng || this.language))
                : t.push(n.lng || this.language);
            const R = (e, t, r) => {
              r = x && r !== c ? r : O;
              this.options.missingKeyHandler
                ? this.options.missingKeyHandler(e, i, t, r, N, n)
                : this.backendConnector &&
                  this.backendConnector.saveMissing &&
                  this.backendConnector.saveMissing(e, i, t, r, N, n),
                this.emit('missingKey', e, i, t, c);
            };
            this.options.saveMissing &&
              (this.options.saveMissingPlurals && b
                ? t.forEach((t) => {
                    var e = this.pluralResolver.getSuffixes(t, n);
                    S &&
                      n[`defaultValue${this.options.pluralSeparator}zero`] &&
                      e.indexOf(this.options.pluralSeparator + 'zero') < 0 &&
                      e.push(this.options.pluralSeparator + 'zero'),
                      e.forEach((e) => {
                        R([t], s + e, n['defaultValue' + e] || L);
                      });
                  })
                : R(t, s, L));
          }
          (c = this.extendTranslation(c, r, n, u, a)),
            t && c === s && this.options.appendNamespaceToMissingKey && (c = i + ':' + s),
            (t || e) &&
              this.options.parseMissingKeyHandler &&
              (c =
                'v1' !== this.options.compatibilityAPI
                  ? this.options.parseMissingKeyHandler(
                      this.options.appendNamespaceToMissingKey ? i + ':' + s : s,
                      e ? c : void 0,
                    )
                  : this.options.parseMissingKeyHandler(c));
        }
        return e ? ((u.res = c), (u.usedParams = this.getUsedParamsDetails(n)), u) : c;
      }
      extendTranslation(r, n, a, o, s) {
        var i = this;
        if (this.i18nFormat && this.i18nFormat.parse)
          r = this.i18nFormat.parse(
            r,
            { ...this.options.interpolation.defaultVariables, ...a },
            a.lng || this.language || o.usedLng,
            o.usedNS,
            o.usedKey,
            { resolved: o },
          );
        else if (!a.skipInterpolation) {
          a.interpolation &&
            this.interpolator.init({ ...a, interpolation: { ...this.options.interpolation, ...a.interpolation } });
          var l =
            'string' == typeof r &&
            (a && a.interpolation && void 0 !== a.interpolation.skipOnVariables ? a : this.options).interpolation
              .skipOnVariables;
          let e,
            t =
              (l && ((u = r.match(this.interpolator.nestingRegexp)), (e = u && u.length)),
              a.replace && 'string' != typeof a.replace ? a.replace : a);
          this.options.interpolation.defaultVariables && (t = { ...this.options.interpolation.defaultVariables, ...t }),
            (r = this.interpolator.interpolate(r, t, a.lng || this.language, a)),
            l && ((l = (u = r.match(this.interpolator.nestingRegexp)) && u.length), e < l) && (a.nest = !1),
            !a.lng && 'v1' !== this.options.compatibilityAPI && o && o.res && (a.lng = o.usedLng),
            !1 !== a.nest &&
              (r = this.interpolator.nest(
                r,
                function () {
                  for (var e = arguments.length, t = new Array(e), r = 0; r < e; r++) t[r] = arguments[r];
                  return s && s[0] === t[0] && !a.context
                    ? (i.logger.warn(`It seems you are nesting recursively key: ${t[0]} in key: ` + n[0]), null)
                    : i.translate(...t, n);
                },
                a,
              )),
            a.interpolation && this.interpolator.reset();
        }
        var u = a.postProcess || this.options.postProcess,
          l = 'string' == typeof u ? [u] : u;
        return (r =
          null != r && l && l.length && !1 !== a.applyPostProcessor
            ? h.handle(
                l,
                r,
                n,
                this.options && this.options.postProcessPassResolved
                  ? { i18nResolved: { ...o, usedParams: this.getUsedParamsDetails(a) }, ...a }
                  : a,
                this,
              )
            : r);
      }
      resolve(e) {
        let f = 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : {},
          h,
          n,
          p,
          d,
          a;
        return (
          (e = 'string' == typeof e ? [e] : e).forEach((t) => {
            if (!this.isValidLookup(h)) {
              t = this.extractFromKey(t, f);
              const i = t.key;
              n = i;
              let e = t.namespaces;
              this.options.fallbackNS && (e = e.concat(this.options.fallbackNS));
              const l = void 0 !== f.count && 'string' != typeof f.count,
                u = l && !f.ordinal && 0 === f.count && this.pluralResolver.shouldUseIntlApi(),
                c =
                  void 0 !== f.context &&
                  ('string' == typeof f.context || 'number' == typeof f.context) &&
                  '' !== f.context,
                r = f.lngs || this.languageUtils.toResolveHierarchy(f.lng || this.language, f.fallbackLng);
              e.forEach((s) => {
                this.isValidLookup(h) ||
                  ((a = s),
                  !o[r[0] + '-' + s] &&
                    this.utils &&
                    this.utils.hasLoadedNamespace &&
                    !this.utils.hasLoadedNamespace(a) &&
                    ((o[r[0] + '-' + s] = !0),
                    this.logger.warn(
                      `key "${n}" for languages "${r.join(', ')}" won't get resolved as namespace "${a}" was not yet loaded`,
                      'This means something IS WRONG in your setup. You access the t function before i18next.init / i18next.loadNamespace / i18next.changeLanguage was done. Wait for the callback or Promise to resolve before accessing it!!!',
                    )),
                  r.forEach((t) => {
                    if (!this.isValidLookup(h)) {
                      d = t;
                      var e,
                        r = [i];
                      if (this.i18nFormat && this.i18nFormat.addLookupKeys)
                        this.i18nFormat.addLookupKeys(r, i, t, s, f);
                      else {
                        let e;
                        l && (e = this.pluralResolver.getSuffix(t, f.count, f));
                        var n,
                          a = this.options.pluralSeparator + 'zero',
                          o = this.options.pluralSeparator + 'ordinal' + this.options.pluralSeparator;
                        l &&
                          (r.push(i + e),
                          f.ordinal && 0 === e.indexOf(o) && r.push(i + e.replace(o, this.options.pluralSeparator)),
                          u) &&
                          r.push(i + a),
                          c &&
                            ((n = '' + i + this.options.contextSeparator + f.context), r.push(n), l) &&
                            (r.push(n + e),
                            f.ordinal && 0 === e.indexOf(o) && r.push(n + e.replace(o, this.options.pluralSeparator)),
                            u) &&
                            r.push(n + a);
                      }
                      for (; (e = r.pop()); ) this.isValidLookup(h) || ((p = e), (h = this.getResource(t, s, e, f)));
                    }
                  }));
              });
            }
          }),
          { res: h, usedKey: n, exactUsedKey: p, usedLng: d, usedNS: a }
        );
      }
      isValidLookup(e) {
        return !(
          void 0 === e ||
          (!this.options.returnNull && null === e) ||
          (!this.options.returnEmptyString && '' === e)
        );
      }
      getResource(e, t, r) {
        var n = 3 < arguments.length && void 0 !== arguments[3] ? arguments[3] : {};
        return (this.i18nFormat && this.i18nFormat.getResource ? this.i18nFormat : this.resourceStore).getResource(
          e,
          t,
          r,
          n,
        );
      }
      getUsedParamsDetails() {
        var e = 0 < arguments.length && void 0 !== arguments[0] ? arguments[0] : {},
          t = e.replace && 'string' != typeof e.replace;
        let r = t ? e.replace : e;
        if (
          (t && void 0 !== e.count && (r.count = e.count),
          this.options.interpolation.defaultVariables && (r = { ...this.options.interpolation.defaultVariables, ...r }),
          !t)
        ) {
          r = { ...r };
          for (const n of [
            'defaultValue',
            'ordinal',
            'context',
            'replace',
            'lng',
            'lngs',
            'fallbackLng',
            'ns',
            'keySeparator',
            'nsSeparator',
            'returnObjects',
            'returnDetails',
            'joinArrays',
            'postProcess',
            'interpolation',
          ])
            delete r[n];
        }
        return r;
      }
      static hasDefaultValue(e) {
        var t = 'defaultValue';
        for (const r in e)
          if (Object.prototype.hasOwnProperty.call(e, r) && t === r.substring(0, t.length) && void 0 !== e[r])
            return !0;
        return !1;
      }
    }),
    (p = class {
      constructor(e) {
        (this.options = e),
          (this.supportedLngs = this.options.supportedLngs || !1),
          (this.logger = c.create('languageUtils'));
      }
      getScriptPartFromCode(e) {
        return !(e = j(e)) ||
          e.indexOf('-') < 0 ||
          2 === (e = e.split('-')).length ||
          (e.pop(), 'x' === e[e.length - 1].toLowerCase())
          ? null
          : this.formatLanguageCode(e.join('-'));
      }
      getLanguagePartFromCode(e) {
        return !(e = j(e)) || e.indexOf('-') < 0 ? e : ((e = e.split('-')), this.formatLanguageCode(e[0]));
      }
      formatLanguageCode(t) {
        if ('string' == typeof t && -1 < t.indexOf('-')) {
          var r = ['hans', 'hant', 'latn', 'cyrl', 'cans', 'mong', 'arab'];
          let e = t.split('-');
          return (
            this.options.lowerCaseLng
              ? (e = e.map((e) => e.toLowerCase()))
              : 2 === e.length
                ? ((e[0] = e[0].toLowerCase()),
                  (e[1] = e[1].toUpperCase()),
                  -1 < r.indexOf(e[1].toLowerCase()) && (e[1] = M(e[1].toLowerCase())))
                : 3 === e.length &&
                  ((e[0] = e[0].toLowerCase()),
                  2 === e[1].length && (e[1] = e[1].toUpperCase()),
                  'sgn' !== e[0] && 2 === e[2].length && (e[2] = e[2].toUpperCase()),
                  -1 < r.indexOf(e[1].toLowerCase()) && (e[1] = M(e[1].toLowerCase())),
                  -1 < r.indexOf(e[2].toLowerCase())) &&
                  (e[2] = M(e[2].toLowerCase())),
            e.join('-')
          );
        }
        return this.options.cleanCode || this.options.lowerCaseLng ? t.toLowerCase() : t;
      }
      isSupportedCode(e) {
        return (
          ('languageOnly' !== this.options.load && !this.options.nonExplicitSupportedLngs) ||
            (e = this.getLanguagePartFromCode(e)),
          !this.supportedLngs || !this.supportedLngs.length || -1 < this.supportedLngs.indexOf(e)
        );
      }
      getBestMatchFromCodes(e) {
        if (!e) return null;
        let r;
        return (
          e.forEach((e) => {
            r || ((e = this.formatLanguageCode(e)), this.options.supportedLngs && !this.isSupportedCode(e)) || (r = e);
          }),
          !r &&
            this.options.supportedLngs &&
            e.forEach((e) => {
              if (!r) {
                const t = this.getLanguagePartFromCode(e);
                if (this.isSupportedCode(t)) return (r = t);
                r = this.options.supportedLngs.find((e) =>
                  e === t ||
                  (!(e.indexOf('-') < 0 && t.indexOf('-') < 0) &&
                    ((0 < e.indexOf('-') && t.indexOf('-') < 0 && e.substring(0, e.indexOf('-')) === t) ||
                      (0 === e.indexOf(t) && 1 < t.length)))
                    ? e
                    : void 0,
                );
              }
            }),
          (r = r || this.getFallbackCodes(this.options.fallbackLng)[0])
        );
      }
      getFallbackCodes(e, t) {
        if (!e) return [];
        if (
          ('string' == typeof (e = 'function' == typeof e ? e(t) : e) && (e = [e]),
          '[object Array]' === Object.prototype.toString.apply(e))
        )
          return e;
        if (!t) return e.default || [];
        let r = e[t];
        return (
          (r =
            (r =
              (r = (r = r || e[this.getScriptPartFromCode(t)]) || e[this.formatLanguageCode(t)]) ||
              e[this.getLanguagePartFromCode(t)]) || e.default) || []
        );
      }
      toResolveHierarchy(e, t) {
        t = this.getFallbackCodes(t || this.options.fallbackLng || [], e);
        const r = [],
          n = (e) => {
            e &&
              (this.isSupportedCode(e)
                ? r.push(e)
                : this.logger.warn('rejecting language code not found in supportedLngs: ' + e));
          };
        return (
          'string' == typeof e && (-1 < e.indexOf('-') || -1 < e.indexOf('_'))
            ? ('languageOnly' !== this.options.load && n(this.formatLanguageCode(e)),
              'languageOnly' !== this.options.load &&
                'currentOnly' !== this.options.load &&
                n(this.getScriptPartFromCode(e)),
              'currentOnly' !== this.options.load && n(this.getLanguagePartFromCode(e)))
            : 'string' == typeof e && n(this.formatLanguageCode(e)),
          t.forEach((e) => {
            r.indexOf(e) < 0 && n(this.formatLanguageCode(e));
          }),
          r
        );
      }
    }),
    (K = [
      {
        lngs: [
          'ach',
          'ak',
          'am',
          'arn',
          'br',
          'fil',
          'gun',
          'ln',
          'mfe',
          'mg',
          'mi',
          'oc',
          'pt',
          'pt-BR',
          'tg',
          'tl',
          'ti',
          'tr',
          'uz',
          'wa',
        ],
        nr: [1, 2],
        fc: 1,
      },
      {
        lngs: [
          'af',
          'an',
          'ast',
          'az',
          'bg',
          'bn',
          'ca',
          'da',
          'de',
          'dev',
          'el',
          'en',
          'eo',
          'es',
          'et',
          'eu',
          'fi',
          'fo',
          'fur',
          'fy',
          'gl',
          'gu',
          'ha',
          'hi',
          'hu',
          'hy',
          'ia',
          'it',
          'kk',
          'kn',
          'ku',
          'lb',
          'mai',
          'ml',
          'mn',
          'mr',
          'nah',
          'nap',
          'nb',
          'ne',
          'nl',
          'nn',
          'no',
          'nso',
          'pa',
          'pap',
          'pms',
          'ps',
          'pt-PT',
          'rm',
          'sco',
          'se',
          'si',
          'so',
          'son',
          'sq',
          'sv',
          'sw',
          'ta',
          'te',
          'tk',
          'ur',
          'yo',
        ],
        nr: [1, 2],
        fc: 2,
      },
      {
        lngs: [
          'ay',
          'bo',
          'cgg',
          'fa',
          'ht',
          'id',
          'ja',
          'jbo',
          'ka',
          'km',
          'ko',
          'ky',
          'lo',
          'ms',
          'sah',
          'su',
          'th',
          'tt',
          'ug',
          'vi',
          'wo',
          'zh',
        ],
        nr: [1],
        fc: 3,
      },
      { lngs: ['be', 'bs', 'cnr', 'dz', 'hr', 'ru', 'sr', 'uk'], nr: [1, 2, 5], fc: 4 },
      { lngs: ['ar'], nr: [0, 1, 2, 3, 11, 100], fc: 5 },
      { lngs: ['cs', 'sk'], nr: [1, 2, 5], fc: 6 },
      { lngs: ['csb', 'pl'], nr: [1, 2, 5], fc: 7 },
      { lngs: ['cy'], nr: [1, 2, 3, 8], fc: 8 },
      { lngs: ['fr'], nr: [1, 2], fc: 9 },
      { lngs: ['ga'], nr: [1, 2, 3, 7, 11], fc: 10 },
      { lngs: ['gd'], nr: [1, 2, 3, 20], fc: 11 },
      { lngs: ['is'], nr: [1, 2], fc: 12 },
      { lngs: ['jv'], nr: [0, 1], fc: 13 },
      { lngs: ['kw'], nr: [1, 2, 3, 4], fc: 14 },
      { lngs: ['lt'], nr: [1, 2, 10], fc: 15 },
      { lngs: ['lv'], nr: [1, 2, 0], fc: 16 },
      { lngs: ['mk'], nr: [1, 2], fc: 17 },
      { lngs: ['mnk'], nr: [0, 1, 2], fc: 18 },
      { lngs: ['mt'], nr: [1, 2, 11, 20], fc: 19 },
      { lngs: ['or'], nr: [2, 1], fc: 2 },
      { lngs: ['ro'], nr: [1, 2, 20], fc: 20 },
      { lngs: ['sl'], nr: [5, 1, 2, 3], fc: 21 },
      { lngs: ['he', 'iw'], nr: [1, 2, 20, 21], fc: 22 },
    ]),
    (H = {
      1: function (e) {
        return Number(1 < e);
      },
      2: function (e) {
        return Number(1 != e);
      },
      3: function (e) {
        return 0;
      },
      4: function (e) {
        return Number(
          e % 10 == 1 && e % 100 != 11 ? 0 : 2 <= e % 10 && e % 10 <= 4 && (e % 100 < 10 || 20 <= e % 100) ? 1 : 2,
        );
      },
      5: function (e) {
        return Number(0 == e ? 0 : 1 == e ? 1 : 2 == e ? 2 : 3 <= e % 100 && e % 100 <= 10 ? 3 : 11 <= e % 100 ? 4 : 5);
      },
      6: function (e) {
        return Number(1 == e ? 0 : 2 <= e && e <= 4 ? 1 : 2);
      },
      7: function (e) {
        return Number(1 == e ? 0 : 2 <= e % 10 && e % 10 <= 4 && (e % 100 < 10 || 20 <= e % 100) ? 1 : 2);
      },
      8: function (e) {
        return Number(1 == e ? 0 : 2 == e ? 1 : 8 != e && 11 != e ? 2 : 3);
      },
      9: function (e) {
        return Number(2 <= e);
      },
      10: function (e) {
        return Number(1 == e ? 0 : 2 == e ? 1 : e < 7 ? 2 : e < 11 ? 3 : 4);
      },
      11: function (e) {
        return Number(1 == e || 11 == e ? 0 : 2 == e || 12 == e ? 1 : 2 < e && e < 20 ? 2 : 3);
      },
      12: function (e) {
        return Number(e % 10 != 1 || e % 100 == 11);
      },
      13: function (e) {
        return Number(0 !== e);
      },
      14: function (e) {
        return Number(1 == e ? 0 : 2 == e ? 1 : 3 == e ? 2 : 3);
      },
      15: function (e) {
        return Number(e % 10 == 1 && e % 100 != 11 ? 0 : 2 <= e % 10 && (e % 100 < 10 || 20 <= e % 100) ? 1 : 2);
      },
      16: function (e) {
        return Number(e % 10 == 1 && e % 100 != 11 ? 0 : 0 !== e ? 1 : 2);
      },
      17: function (e) {
        return Number(1 == e || (e % 10 == 1 && e % 100 != 11) ? 0 : 1);
      },
      18: function (e) {
        return Number(0 == e ? 0 : 1 == e ? 1 : 2);
      },
      19: function (e) {
        return Number(1 == e ? 0 : 0 == e || (1 < e % 100 && e % 100 < 11) ? 1 : 10 < e % 100 && e % 100 < 20 ? 2 : 3);
      },
      20: function (e) {
        return Number(1 == e ? 0 : 0 == e || (0 < e % 100 && e % 100 < 20) ? 1 : 2);
      },
      21: function (e) {
        return Number(e % 100 == 1 ? 1 : e % 100 == 2 ? 2 : e % 100 == 3 || e % 100 == 4 ? 3 : 0);
      },
      22: function (e) {
        return Number(1 == e ? 0 : 2 == e ? 1 : (e < 0 || 10 < e) && e % 10 == 0 ? 2 : 3);
      },
    }),
    (J = ['v1', 'v2', 'v3']),
    (W = ['v4']),
    (a = { zero: 0, one: 1, two: 2, few: 3, many: 4, other: 5 }),
    (G = class {
      constructor(e) {
        var t = 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : {};
        (this.languageUtils = e),
          (this.options = t),
          (this.logger = c.create('pluralResolver')),
          (this.options.compatibilityJSON && !W.includes(this.options.compatibilityJSON)) ||
            ('undefined' != typeof Intl && Intl.PluralRules) ||
            ((this.options.compatibilityJSON = 'v3'),
            this.logger.error(
              'Your environment seems not to be Intl API compatible, use an Intl.PluralRules polyfill. Will fallback to the compatibilityJSON v3 format handling.',
            )),
          (this.rules = de());
      }
      addRule(e, t) {
        this.rules[e] = t;
      }
      getRule(e) {
        var t = 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : {};
        if (this.shouldUseIntlApi())
          try {
            return new Intl.PluralRules(j('dev' === e ? 'en' : e), { type: t.ordinal ? 'ordinal' : 'cardinal' });
          } catch (e) {
            return;
          }
        return this.rules[e] || this.rules[this.languageUtils.getLanguagePartFromCode(e)];
      }
      needsPlural(e) {
        e = this.getRule(e, 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : {});
        return this.shouldUseIntlApi()
          ? e && 1 < e.resolvedOptions().pluralCategories.length
          : e && 1 < e.numbers.length;
      }
      getPluralFormsOfKey(e, t) {
        return this.getSuffixes(e, 2 < arguments.length && void 0 !== arguments[2] ? arguments[2] : {}).map(
          (e) => '' + t + e,
        );
      }
      getSuffixes(t) {
        let r = 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : {};
        var e = this.getRule(t, r);
        return e
          ? this.shouldUseIntlApi()
            ? e
                .resolvedOptions()
                .pluralCategories.sort((e, t) => a[e] - a[t])
                .map((e) => '' + this.options.prepend + (r.ordinal ? 'ordinal' + this.options.prepend : '') + e)
            : e.numbers.map((e) => this.getSuffix(t, e, r))
          : [];
      }
      getSuffix(e, t) {
        var r = 2 < arguments.length && void 0 !== arguments[2] ? arguments[2] : {},
          n = this.getRule(e, r);
        return n
          ? this.shouldUseIntlApi()
            ? '' + this.options.prepend + (r.ordinal ? 'ordinal' + this.options.prepend : '') + n.select(t)
            : this.getSuffixRetroCompatible(n, t)
          : (this.logger.warn('no plural rule found for: ' + e), '');
      }
      getSuffixRetroCompatible(e, t) {
        t = e.noAbs ? e.plurals(t) : e.plurals(Math.abs(t));
        let r = e.numbers[t];
        this.options.simplifyPluralSuffix &&
          2 === e.numbers.length &&
          1 === e.numbers[0] &&
          (2 === r ? (r = 'plural') : 1 === r && (r = ''));
        var n = () => (this.options.prepend && r.toString() ? this.options.prepend + r.toString() : r.toString());
        return 'v1' === this.options.compatibilityJSON
          ? 1 === r
            ? ''
            : 'number' == typeof r
              ? '_plural_' + r.toString()
              : n()
          : 'v2' === this.options.compatibilityJSON ||
              (this.options.simplifyPluralSuffix && 2 === e.numbers.length && 1 === e.numbers[0])
            ? n()
            : this.options.prepend && t.toString()
              ? this.options.prepend + t.toString()
              : t.toString();
      }
      shouldUseIntlApi() {
        return !J.includes(this.options.compatibilityJSON);
      }
    }),
    (Y = class {
      constructor() {
        var e = 0 < arguments.length && void 0 !== arguments[0] ? arguments[0] : {};
        (this.logger = c.create('interpolator')),
          (this.options = e),
          (this.format = (e.interpolation && e.interpolation.format) || ((e) => e)),
          this.init(e);
      }
      init() {
        var e = 0 < arguments.length && void 0 !== arguments[0] ? arguments[0] : {},
          e = (e.interpolation || (e.interpolation = { escapeValue: !0 }), e.interpolation);
        (this.escape = void 0 !== e.escape ? e.escape : he),
          (this.escapeValue = void 0 === e.escapeValue || e.escapeValue),
          (this.useRawValueToEscape = void 0 !== e.useRawValueToEscape && e.useRawValueToEscape),
          (this.prefix = e.prefix ? R(e.prefix) : e.prefixEscaped || '{{'),
          (this.suffix = e.suffix ? R(e.suffix) : e.suffixEscaped || '}}'),
          (this.formatSeparator = e.formatSeparator || e.formatSeparator || ','),
          (this.unescapePrefix = e.unescapeSuffix ? '' : e.unescapePrefix || '-'),
          (this.unescapeSuffix = (!this.unescapePrefix && e.unescapeSuffix) || ''),
          (this.nestingPrefix = e.nestingPrefix ? R(e.nestingPrefix) : e.nestingPrefixEscaped || R('$t(')),
          (this.nestingSuffix = e.nestingSuffix ? R(e.nestingSuffix) : e.nestingSuffixEscaped || R(')')),
          (this.nestingOptionsSeparator = e.nestingOptionsSeparator || e.nestingOptionsSeparator || ','),
          (this.maxReplaces = e.maxReplaces || 1e3),
          (this.alwaysFormat = void 0 !== e.alwaysFormat && e.alwaysFormat),
          this.resetRegExp();
      }
      reset() {
        this.options && this.init(this.options);
      }
      resetRegExp() {
        var e = (e, t) => (e && e.source === t ? ((e.lastIndex = 0), e) : new RegExp(t, 'g'));
        (this.regexp = e(this.regexp, this.prefix + '(.+?)' + this.suffix)),
          (this.regexpUnescape = e(
            this.regexpUnescape,
            '' + this.prefix + this.unescapePrefix + '(.+?)' + this.unescapeSuffix + this.suffix,
          )),
          (this.nestingRegexp = e(this.nestingRegexp, this.nestingPrefix + '(.+?)' + this.nestingSuffix));
      }
      interpolate(n, r, a, o) {
        let s, i, l;
        const u = (this.options && this.options.interpolation && this.options.interpolation.defaultVariables) || {};
        function t(e) {
          return e.replace(/\$/g, '$$$$');
        }
        const c = (e) => {
            var t;
            return e.indexOf(this.formatSeparator) < 0
              ? ((t = ge(r, u, e, this.options.keySeparator, this.options.ignoreJSONStructure)),
                this.alwaysFormat ? this.format(t, void 0, a, { ...o, ...r, interpolationkey: e }) : t)
              : ((e = (t = e.split(this.formatSeparator)).shift().trim()),
                (t = t.join(this.formatSeparator).trim()),
                this.format(ge(r, u, e, this.options.keySeparator, this.options.ignoreJSONStructure), t, a, {
                  ...o,
                  ...r,
                  interpolationkey: e,
                }));
          },
          f = (this.resetRegExp(), (o && o.missingInterpolationHandler) || this.options.missingInterpolationHandler),
          h = (o && o.interpolation && void 0 !== o.interpolation.skipOnVariables ? o : this.options).interpolation
            .skipOnVariables;
        return (
          [
            { regex: this.regexpUnescape, safeValue: (e) => t(e) },
            { regex: this.regexp, safeValue: (e) => (this.escapeValue ? t(this.escape(e)) : t(e)) },
          ].forEach((e) => {
            for (l = 0; (s = e.regex.exec(n)); ) {
              var t = s[1].trim();
              if (void 0 === (i = c(t)))
                if ('function' == typeof f) {
                  var r = f(n, s, o);
                  i = 'string' == typeof r ? r : '';
                } else {
                  if (!o || !Object.prototype.hasOwnProperty.call(o, t)) {
                    if (h) {
                      i = s[0];
                      continue;
                    }
                    this.logger.warn(`missed to pass in variable ${t} for interpolating ` + n);
                  }
                  i = '';
                }
              else 'string' == typeof i || this.useRawValueToEscape || (i = ie(i));
              r = e.safeValue(i);
              if (
                ((n = n.replace(s[0], r)),
                h ? ((e.regex.lastIndex += i.length), (e.regex.lastIndex -= s[0].length)) : (e.regex.lastIndex = 0),
                ++l >= this.maxReplaces)
              )
                break;
            }
          }),
          n
        );
      }
      nest(r, n) {
        let a = 2 < arguments.length && void 0 !== arguments[2] ? arguments[2] : {},
          o,
          s,
          i;
        function l(r, e) {
          var n = this.nestingOptionsSeparator;
          if (!(r.indexOf(n) < 0)) {
            var a = r.split(new RegExp(n + '[ ]*{'));
            let t = '{' + a[1];
            r = a[0];
            var a = (t = this.interpolate(t, i)).match(/'/g),
              o = t.match(/"/g);
            ((a && a.length % 2 == 0 && !o) || o.length % 2 != 0) && (t = t.replace(/'/g, '"'));
            try {
              (i = JSON.parse(t)), e && (i = { ...e, ...i });
            } catch (e) {
              return this.logger.warn('failed parsing options string in nesting for key ' + r, e), '' + r + n + t;
            }
            i.defaultValue && -1 < i.defaultValue.indexOf(this.prefix) && delete i.defaultValue;
          }
          return r;
        }
        for (; (o = this.nestingRegexp.exec(r)); ) {
          let e = [],
            t =
              (((i = (i = { ...a }).replace && 'string' != typeof i.replace ? i.replace : i).applyPostProcessor = !1),
              delete i.defaultValue,
              !1);
          var u;
          if (
            (-1 === o[0].indexOf(this.formatSeparator) ||
              /{.*}/.test(o[1]) ||
              ((u = o[1].split(this.formatSeparator).map((e) => e.trim())), (o[1] = u.shift()), (e = u), (t = !0)),
            (s = n(l.call(this, o[1].trim(), i), i)) && o[0] === r && 'string' != typeof s)
          )
            return s;
          (s = 'string' != typeof s ? ie(s) : s) ||
            (this.logger.warn(`missed to resolve ${o[1]} for nesting ` + r), (s = '')),
            t && (s = e.reduce((e, t) => this.format(e, t, a.lng, { ...a, interpolationkey: o[1].trim() }), s.trim())),
            (r = r.replace(o[0], s)),
            (this.regexp.lastIndex = 0);
        }
        return r;
      }
    }),
    (X = class {
      constructor() {
        var e = 0 < arguments.length && void 0 !== arguments[0] ? arguments[0] : {};
        (this.logger = c.create('formatter')),
          (this.options = e),
          (this.formats = {
            number: E((e, t) => {
              const r = new Intl.NumberFormat(e, { ...t });
              return (e) => r.format(e);
            }),
            currency: E((e, t) => {
              const r = new Intl.NumberFormat(e, { ...t, style: 'currency' });
              return (e) => r.format(e);
            }),
            datetime: E((e, t) => {
              const r = new Intl.DateTimeFormat(e, { ...t });
              return (e) => r.format(e);
            }),
            relativetime: E((e, t) => {
              const r = new Intl.RelativeTimeFormat(e, { ...t });
              return (e) => r.format(e, t.range || 'day');
            }),
            list: E((e, t) => {
              const r = new Intl.ListFormat(e, { ...t });
              return (e) => r.format(e);
            }),
          }),
          this.init(e);
      }
      init(e) {
        var t = (1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : { interpolation: {} }).interpolation;
        this.formatSeparator = t.formatSeparator || t.formatSeparator || ',';
      }
      add(e, t) {
        this.formats[e.toLowerCase().trim()] = t;
      }
      addCached(e, t) {
        this.formats[e.toLowerCase().trim()] = E(t);
      }
      format(e, t, s) {
        let i = 3 < arguments.length && void 0 !== arguments[3] ? arguments[3] : {};
        return t.split(this.formatSeparator).reduce((t, r) => {
          var { formatName: r, formatOptions: n } = be(r);
          if (this.formats[r]) {
            let e = t;
            try {
              var a = (i && i.formatParams && i.formatParams[i.interpolationkey]) || {},
                o = a.locale || a.lng || i.locale || i.lng || s;
              e = this.formats[r](t, o, { ...n, ...i, ...a });
            } catch (e) {
              this.logger.warn(e);
            }
            return e;
          }
          return this.logger.warn('there was no format function for ' + r), t;
        }, e);
      }
    }),
    (Z = class extends n {
      constructor(e, t, r) {
        var n = 3 < arguments.length && void 0 !== arguments[3] ? arguments[3] : {};
        super(),
          (this.backend = e),
          (this.store = t),
          (this.services = r),
          (this.languageUtils = r.languageUtils),
          (this.options = n),
          (this.logger = c.create('backendConnector')),
          (this.waitingReads = []),
          (this.maxParallelReads = n.maxParallelReads || 10),
          (this.readingCalls = 0),
          (this.maxRetries = 0 <= n.maxRetries ? n.maxRetries : 5),
          (this.retryTimeout = 1 <= n.retryTimeout ? n.retryTimeout : 350),
          (this.state = {}),
          (this.queue = []),
          this.backend && this.backend.init && this.backend.init(r, n.backend, n);
      }
      queueLoad(e, t, a, r) {
        const o = {},
          s = {},
          i = {},
          l = {};
        return (
          e.forEach((r) => {
            let n = !0;
            t.forEach((e) => {
              var t = r + '|' + e;
              !a.reload && this.store.hasResourceBundle(r, e)
                ? (this.state[t] = 2)
                : this.state[t] < 0 ||
                  (1 === this.state[t]
                    ? void 0 === s[t] && (s[t] = !0)
                    : ((this.state[t] = 1),
                      (n = !1),
                      void 0 === s[t] && (s[t] = !0),
                      void 0 === o[t] && (o[t] = !0),
                      void 0 === l[e] && (l[e] = !0)));
            }),
              n || (i[r] = !0);
          }),
          (Object.keys(o).length || Object.keys(s).length) &&
            this.queue.push({ pending: s, pendingCount: Object.keys(s).length, loaded: {}, errors: [], callback: r }),
          {
            toLoad: Object.keys(o),
            pending: Object.keys(s),
            toLoadLanguages: Object.keys(i),
            toLoadNamespaces: Object.keys(l),
          }
        );
      }
      loaded(e, t, r) {
        var n = e.split('|');
        const a = n[0],
          o = n[1],
          s =
            (t && this.emit('failedLoading', a, o, t),
            r && this.store.addResourceBundle(a, o, r, void 0, void 0, { skipCopy: !0 }),
            (this.state[e] = t ? -1 : 2),
            {});
        this.queue.forEach((r) => {
          ce(r.loaded, [a], o),
            me(r, e),
            t && r.errors.push(t),
            0 !== r.pendingCount ||
              r.done ||
              (Object.keys(r.loaded).forEach((t) => {
                s[t] || (s[t] = {});
                var e = r.loaded[t];
                e.length &&
                  e.forEach((e) => {
                    void 0 === s[t][e] && (s[t][e] = !0);
                  });
              }),
              (r.done = !0),
              r.errors.length ? r.callback(r.errors) : r.callback());
        }),
          this.emit('loaded', s),
          (this.queue = this.queue.filter((e) => !e.done));
      }
      read(n, a, o) {
        let s = 3 < arguments.length && void 0 !== arguments[3] ? arguments[3] : 0,
          i = 4 < arguments.length && void 0 !== arguments[4] ? arguments[4] : this.retryTimeout,
          l = 5 < arguments.length ? arguments[5] : void 0;
        if (!n.length) return l(null, {});
        if (this.readingCalls >= this.maxParallelReads)
          this.waitingReads.push({ lng: n, ns: a, fcName: o, tried: s, wait: i, callback: l });
        else {
          this.readingCalls++;
          const r = (e, t) => {
            var r;
            this.readingCalls--,
              0 < this.waitingReads.length &&
                ((r = this.waitingReads.shift()), this.read(r.lng, r.ns, r.fcName, r.tried, r.wait, r.callback)),
              e && t && s < this.maxRetries
                ? setTimeout(() => {
                    this.read.call(this, n, a, o, s + 1, 2 * i, l);
                  }, i)
                : l(e, t);
          };
          var e = this.backend[o].bind(this.backend);
          if (2 !== e.length) return e(n, a, r);
          try {
            var t = e(n, a);
            t && 'function' == typeof t.then ? t.then((e) => r(null, e)).catch(r) : r(null, t);
          } catch (e) {
            r(e);
          }
        }
      }
      prepareLoading(e, t) {
        var r = 2 < arguments.length && void 0 !== arguments[2] ? arguments[2] : {},
          n = 3 < arguments.length ? arguments[3] : void 0;
        if (!this.backend)
          return this.logger.warn('No backend was added via i18next.use. Will not load resources.'), n && n();
        'string' == typeof e && (e = this.languageUtils.toResolveHierarchy(e));
        e = this.queueLoad(e, (t = 'string' == typeof t ? [t] : t), r, n);
        if (!e.toLoad.length) return e.pending.length || n(), null;
        e.toLoad.forEach((e) => {
          this.loadOne(e);
        });
      }
      load(e, t, r) {
        this.prepareLoading(e, t, {}, r);
      }
      reload(e, t, r) {
        this.prepareLoading(e, t, { reload: !0 }, r);
      }
      loadOne(r) {
        let n = 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : '';
        var e = r.split('|');
        const a = e[0],
          o = e[1];
        this.read(a, o, 'read', void 0, void 0, (e, t) => {
          e && this.logger.warn(`${n}loading namespace ${o} for language ${a} failed`, e),
            !e && t && this.logger.log(`${n}loaded namespace ${o} for language ` + a, t),
            this.loaded(r, e, t);
        });
      }
      saveMissing(t, r, n, a, o) {
        var s = 5 < arguments.length && void 0 !== arguments[5] ? arguments[5] : {};
        let i = 6 < arguments.length && void 0 !== arguments[6] ? arguments[6] : () => {};
        if (this.services.utils && this.services.utils.hasLoadedNamespace && !this.services.utils.hasLoadedNamespace(r))
          this.logger.warn(
            `did not save key "${n}" as the namespace "${r}" was not yet loaded`,
            'This means something IS WRONG in your setup. You access the t function before i18next.init / i18next.loadNamespace / i18next.changeLanguage was done. Wait for the callback or Promise to resolve before accessing it!!!',
          );
        else if (null != n && '' !== n) {
          if (this.backend && this.backend.create) {
            (s = { ...s, isUpdate: o }), (o = this.backend.create.bind(this.backend));
            if (o.length < 6)
              try {
                let e;
                (e = 5 === o.length ? o(t, r, n, a, s) : o(t, r, n, a)) && 'function' == typeof e.then
                  ? e.then((e) => i(null, e)).catch(i)
                  : i(null, e);
              } catch (e) {
                i(e);
              }
            else o(t, r, n, a, i, s);
          }
          t && t[0] && this.store.addResource(t[0], r, n, a);
        }
      }
    }),
    (s = class extends n {
      constructor() {
        let e = 0 < arguments.length && void 0 !== arguments[0] ? arguments[0] : {},
          t = 1 < arguments.length ? arguments[1] : void 0;
        if (
          (super(),
          (this.options = ye(e)),
          (this.services = {}),
          (this.logger = c),
          (this.modules = { external: [] }),
          we(this),
          t && !this.isInitialized && !e.isClone)
        ) {
          if (!this.options.initImmediate) return this.init(e, t), this;
          setTimeout(() => {
            this.init(e, t);
          }, 0);
        }
      }
      init() {
        var a = this;
        let e = 0 < arguments.length && void 0 !== arguments[0] ? arguments[0] : {},
          r = 1 < arguments.length ? arguments[1] : void 0;
        (this.isInitializing = !0),
          'function' == typeof e && ((r = e), (e = {})),
          !e.defaultNS &&
            !1 !== e.defaultNS &&
            e.ns &&
            ('string' == typeof e.ns
              ? (e.defaultNS = e.ns)
              : e.ns.indexOf('translation') < 0 && (e.defaultNS = e.ns[0]));
        var t = ve();
        function n(e) {
          return e ? ('function' == typeof e ? new e() : e) : null;
        }
        if (
          ((this.options = { ...t, ...this.options, ...ye(e) }),
          'v1' !== this.options.compatibilityAPI &&
            (this.options.interpolation = { ...t.interpolation, ...this.options.interpolation }),
          void 0 !== e.keySeparator && (this.options.userDefinedKeySeparator = e.keySeparator),
          void 0 !== e.nsSeparator && (this.options.userDefinedNsSeparator = e.nsSeparator),
          !this.options.isClone)
        ) {
          this.modules.logger ? c.init(n(this.modules.logger), this.options) : c.init(null, this.options);
          let e;
          this.modules.formatter ? (e = this.modules.formatter) : 'undefined' != typeof Intl && (e = X);
          var o = new p(this.options),
            s = ((this.store = new f(this.options.resources, this.options)), this.services);
          (s.logger = c),
            (s.resourceStore = this.store),
            (s.languageUtils = o),
            (s.pluralResolver = new G(o, {
              prepend: this.options.pluralSeparator,
              compatibilityJSON: this.options.compatibilityJSON,
              simplifyPluralSuffix: this.options.simplifyPluralSuffix,
            })),
            !e ||
              (this.options.interpolation.format && this.options.interpolation.format !== t.interpolation.format) ||
              ((s.formatter = n(e)),
              s.formatter.init(s, this.options),
              (this.options.interpolation.format = s.formatter.format.bind(s.formatter))),
            (s.interpolator = new Y(this.options)),
            (s.utils = { hasLoadedNamespace: this.hasLoadedNamespace.bind(this) }),
            (s.backendConnector = new Z(n(this.modules.backend), s.resourceStore, s, this.options)),
            s.backendConnector.on('*', function (e) {
              for (var t = arguments.length, r = new Array(1 < t ? t - 1 : 0), n = 1; n < t; n++)
                r[n - 1] = arguments[n];
              a.emit(e, ...r);
            }),
            this.modules.languageDetector &&
              ((s.languageDetector = n(this.modules.languageDetector)), s.languageDetector.init) &&
              s.languageDetector.init(s, this.options.detection, this.options),
            this.modules.i18nFormat &&
              ((s.i18nFormat = n(this.modules.i18nFormat)), s.i18nFormat.init) &&
              s.i18nFormat.init(this),
            (this.translator = new C(this.services, this.options)),
            this.translator.on('*', function (e) {
              for (var t = arguments.length, r = new Array(1 < t ? t - 1 : 0), n = 1; n < t; n++)
                r[n - 1] = arguments[n];
              a.emit(e, ...r);
            }),
            this.modules.external.forEach((e) => {
              e.init && e.init(this);
            });
        }
        (this.format = this.options.interpolation.format),
          (r = r || I),
          !this.options.fallbackLng ||
            this.services.languageDetector ||
            this.options.lng ||
            (0 < (o = this.services.languageUtils.getFallbackCodes(this.options.fallbackLng)).length &&
              'dev' !== o[0] &&
              (this.options.lng = o[0])),
          this.services.languageDetector ||
            this.options.lng ||
            this.logger.warn('init: no languageDetector is used and no lng is defined');
        ['getResource', 'hasResourceBundle', 'getResourceBundle', 'getDataByLanguage'].forEach((e) => {
          this[e] = function () {
            return a.store[e](...arguments);
          };
        });
        ['addResource', 'addResources', 'addResourceBundle', 'removeResourceBundle'].forEach((e) => {
          this[e] = function () {
            return a.store[e](...arguments), a;
          };
        });
        const i = L();
        t = () => {
          var e = (e, t) => {
            (this.isInitializing = !1),
              this.isInitialized &&
                !this.initializedStoreOnce &&
                this.logger.warn('init: i18next is already initialized. You should call init just once!'),
              (this.isInitialized = !0),
              this.options.isClone || this.logger.log('initialized', this.options),
              this.emit('initialized', this.options),
              i.resolve(t),
              r(e, t);
          };
          if (this.languages && 'v1' !== this.options.compatibilityAPI && !this.isInitialized)
            return e(null, this.t.bind(this));
          this.changeLanguage(this.options.lng, e);
        };
        return this.options.resources || !this.options.initImmediate ? t() : setTimeout(t, 0), i;
      }
      loadResources(e) {
        let t = 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : I;
        var r = 'string' == typeof e ? e : this.language;
        if (('function' == typeof e && (t = e), !this.options.resources || this.options.partialBundledLanguages)) {
          if (r && 'cimode' === r.toLowerCase() && (!this.options.preload || 0 === this.options.preload.length))
            return t();
          const n = [],
            a = (e) => {
              e &&
                'cimode' !== e &&
                this.services.languageUtils.toResolveHierarchy(e).forEach((e) => {
                  'cimode' !== e && n.indexOf(e) < 0 && n.push(e);
                });
            };
          r ? a(r) : this.services.languageUtils.getFallbackCodes(this.options.fallbackLng).forEach((e) => a(e)),
            this.options.preload && this.options.preload.forEach((e) => a(e)),
            this.services.backendConnector.load(n, this.options.ns, (e) => {
              e || this.resolvedLanguage || !this.language || this.setResolvedLanguage(this.language), t(e);
            });
        } else t(null);
      }
      reloadResources(e, t, r) {
        const n = L();
        return (
          (e = e || this.languages),
          (t = t || this.options.ns),
          (r = r || I),
          this.services.backendConnector.reload(e, t, (e) => {
            n.resolve(), r(e);
          }),
          n
        );
      }
      use(e) {
        if (!e)
          throw new Error(
            'You are passing an undefined module! Please check the object you are passing to i18next.use()',
          );
        if (e.type)
          return (
            'backend' === e.type && (this.modules.backend = e),
            ('logger' === e.type || (e.log && e.warn && e.error)) && (this.modules.logger = e),
            'languageDetector' === e.type && (this.modules.languageDetector = e),
            'i18nFormat' === e.type && (this.modules.i18nFormat = e),
            'postProcessor' === e.type && h.addPostProcessor(e),
            'formatter' === e.type && (this.modules.formatter = e),
            '3rdParty' === e.type && this.modules.external.push(e),
            this
          );
        throw new Error('You are passing a wrong module! Please check the object you are passing to i18next.use()');
      }
      setResolvedLanguage(e) {
        if (e && this.languages && !(-1 < ['cimode', 'dev'].indexOf(e)))
          for (let e = 0; e < this.languages.length; e++) {
            var t = this.languages[e];
            if (!(-1 < ['cimode', 'dev'].indexOf(t)) && this.store.hasLanguageSomeTranslations(t)) {
              this.resolvedLanguage = t;
              break;
            }
          }
      }
      changeLanguage(r, n) {
        var a = this;
        this.isLanguageChangingTo = r;
        const o = L(),
          s =
            (this.emit('languageChanging', r),
            (e) => {
              (this.language = e),
                (this.languages = this.services.languageUtils.toResolveHierarchy(e)),
                (this.resolvedLanguage = void 0),
                this.setResolvedLanguage(e);
            }),
          i = (e, t) => {
            t
              ? (s(t),
                this.translator.changeLanguage(t),
                (this.isLanguageChangingTo = void 0),
                this.emit('languageChanged', t),
                this.logger.log('languageChanged', t))
              : (this.isLanguageChangingTo = void 0),
              o.resolve(function () {
                return a.t(...arguments);
              }),
              n &&
                n(e, function () {
                  return a.t(...arguments);
                });
          };
        var e = (e) => {
          const t =
            'string' == typeof (e = r || e || !this.services.languageDetector ? e : [])
              ? e
              : this.services.languageUtils.getBestMatchFromCodes(e);
          t &&
            (this.language || s(t),
            this.translator.language || this.translator.changeLanguage(t),
            this.services.languageDetector) &&
            this.services.languageDetector.cacheUserLanguage &&
            this.services.languageDetector.cacheUserLanguage(t),
            this.loadResources(t, (e) => {
              i(e, t);
            });
        };
        return (
          r || !this.services.languageDetector || this.services.languageDetector.async
            ? !r && this.services.languageDetector && this.services.languageDetector.async
              ? 0 === this.services.languageDetector.detect.length
                ? this.services.languageDetector.detect().then(e)
                : this.services.languageDetector.detect(e)
              : e(r)
            : e(this.services.languageDetector.detect()),
          o
        );
      }
      getFixedT(e, t, l) {
        var u = this;
        function c(e, t) {
          let r;
          if ('object' != typeof t) {
            for (var n = arguments.length, a = new Array(2 < n ? n - 2 : 0), o = 2; o < n; o++) a[o - 2] = arguments[o];
            r = u.options.overloadTranslationOptionHandler([e, t].concat(a));
          } else r = { ...t };
          (r.lng = r.lng || c.lng),
            (r.lngs = r.lngs || c.lngs),
            (r.ns = r.ns || c.ns),
            (r.keyPrefix = r.keyPrefix || l || c.keyPrefix);
          const s = u.options.keySeparator || '.';
          let i;
          return (
            (i =
              r.keyPrefix && Array.isArray(e)
                ? e.map((e) => '' + r.keyPrefix + s + e)
                : r.keyPrefix
                  ? '' + r.keyPrefix + s + e
                  : e),
            u.t(i, r)
          );
        }
        return 'string' == typeof e ? (c.lng = e) : (c.lngs = e), (c.ns = t), (c.keyPrefix = l), c;
      }
      t() {
        return this.translator && this.translator.translate(...arguments);
      }
      exists() {
        return this.translator && this.translator.exists(...arguments);
      }
      setDefaultNamespace(e) {
        this.options.defaultNS = e;
      }
      hasLoadedNamespace(e) {
        var t = 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : {};
        if (!this.isInitialized)
          return this.logger.warn('hasLoadedNamespace: i18next was not initialized', this.languages), !1;
        if (!this.languages || !this.languages.length)
          return this.logger.warn('hasLoadedNamespace: i18n.languages were undefined or empty', this.languages), !1;
        var r = t.lng || this.resolvedLanguage || this.languages[0],
          n = !!this.options && this.options.fallbackLng,
          a = this.languages[this.languages.length - 1];
        if ('cimode' === r.toLowerCase()) return !0;
        var o = (e, t) => {
          e = this.services.backendConnector.state[e + '|' + t];
          return -1 === e || 2 === e;
        };
        if (t.precheck) {
          t = t.precheck(this, o);
          if (void 0 !== t) return t;
        }
        return (
          !!this.hasResourceBundle(r, e) ||
          !(
            this.services.backendConnector.backend &&
            (!this.options.resources || this.options.partialBundledLanguages) &&
            (!o(r, e) || (n && !o(a, e)))
          )
        );
      }
      loadNamespaces(e, t) {
        const r = L();
        return this.options.ns
          ? ((e = 'string' == typeof e ? [e] : e).forEach((e) => {
              this.options.ns.indexOf(e) < 0 && this.options.ns.push(e);
            }),
            this.loadResources((e) => {
              r.resolve(), t && t(e);
            }),
            r)
          : (t && t(), Promise.resolve());
      }
      loadLanguages(e, t) {
        const r = L(),
          n = this.options.preload || [];
        e = (e = 'string' == typeof e ? [e] : e).filter(
          (e) => n.indexOf(e) < 0 && this.services.languageUtils.isSupportedCode(e),
        );
        return e.length
          ? ((this.options.preload = n.concat(e)),
            this.loadResources((e) => {
              r.resolve(), t && t(e);
            }),
            r)
          : (t && t(), Promise.resolve());
      }
      dir(e) {
        var t;
        return !(e =
          e ||
          this.resolvedLanguage ||
          (this.languages && 0 < this.languages.length ? this.languages[0] : this.language)) ||
          ((t = (this.services && this.services.languageUtils) || new p(ve())),
          -1 <
            [
              'ar',
              'shu',
              'sqr',
              'ssh',
              'xaa',
              'yhd',
              'yud',
              'aao',
              'abh',
              'abv',
              'acm',
              'acq',
              'acw',
              'acx',
              'acy',
              'adf',
              'ads',
              'aeb',
              'aec',
              'afb',
              'ajp',
              'apc',
              'apd',
              'arb',
              'arq',
              'ars',
              'ary',
              'arz',
              'auz',
              'avl',
              'ayh',
              'ayl',
              'ayn',
              'ayp',
              'bbz',
              'pga',
              'he',
              'iw',
              'ps',
              'pbt',
              'pbu',
              'pst',
              'prp',
              'prd',
              'ug',
              'ur',
              'ydd',
              'yds',
              'yih',
              'ji',
              'yi',
              'hbo',
              'men',
              'xmn',
              'fa',
              'jpr',
              'peo',
              'pes',
              'prs',
              'dv',
              'sam',
              'ckb',
            ].indexOf(t.getLanguagePartFromCode(e))) ||
          1 < e.toLowerCase().indexOf('-arab')
          ? 'rtl'
          : 'ltr';
      }
      static createInstance() {
        return new s(
          0 < arguments.length && void 0 !== arguments[0] ? arguments[0] : {},
          1 < arguments.length ? arguments[1] : void 0,
        );
      }
      cloneInstance() {
        var e = 0 < arguments.length && void 0 !== arguments[0] ? arguments[0] : {},
          t = 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : I,
          r = e.forkResourceStore,
          n = (r && delete e.forkResourceStore, { ...this.options, ...e, isClone: !0 });
        const a = new s(n);
        (void 0 === e.debug && void 0 === e.prefix) || (a.logger = a.logger.clone(e));
        return (
          ['store', 'services', 'language'].forEach((e) => {
            a[e] = this[e];
          }),
          (a.services = { ...this.services }),
          (a.services.utils = { hasLoadedNamespace: a.hasLoadedNamespace.bind(a) }),
          r && ((a.store = new f(this.store.data, n)), (a.services.resourceStore = a.store)),
          (a.translator = new C(a.services, n)),
          a.translator.on('*', function (e) {
            for (var t = arguments.length, r = new Array(1 < t ? t - 1 : 0), n = 1; n < t; n++) r[n - 1] = arguments[n];
            a.emit(e, ...r);
          }),
          a.init(n, t),
          (a.translator.options = n),
          (a.translator.backendConnector.services.utils = { hasLoadedNamespace: a.hasLoadedNamespace.bind(a) }),
          a
        );
      }
      toJSON() {
        return {
          options: this.options,
          store: this.store,
          language: this.language,
          languages: this.languages,
          resolvedLanguage: this.resolvedLanguage,
        };
      }
    }),
    ((n = s.createInstance()).createInstance = s.createInstance),
    n.createInstance,
    n.dir,
    n.init,
    n.loadResources,
    n.reloadResources,
    n.use,
    n.changeLanguage,
    n.getFixedT,
    (d = n.t),
    n.exists,
    n.setDefaultNamespace,
    n.hasLoadedNamespace,
    n.loadNamespaces,
    n.loadLanguages,
    (g = {
      installedExtensions: (n = 'marketplace') + ':installed-extensions',
      installedSnippets: n + ':installed-snippets',
      installedThemes: n + ':installed-themes',
      activeTab: n + ':active-tab',
      tabs: n + ':tabs',
      sort: n + ':sort',
      themeInstalled: n + ':theme-installed',
      localTheme: n + ':local-theme',
      albumArtBasedColor: n + ':albumArtBasedColors',
      albumArtBasedColorMode: n + ':albumArtBasedColorsMode',
      albumArtBasedColorVibrancy: n + ':albumArtBasedColorsVibrancy',
      colorShift: n + ':colorShift',
    }),
    (b = 100),
    (m = ((e, t, r) => {
      r = null != e ? i(F(e)) : {};
      var n = !t && e && e.__esModule ? r : l(r, 'default', { value: e, enumerable: !0 }),
        a = e,
        o = void 0,
        s = void 0;
      if ((a && 'object' == typeof a) || 'function' == typeof a)
        for (let e of u(a))
          U.call(n, e) || e === o || l(n, e, { get: () => a[e], enumerable: !(s = _(a, e)) || s.enumerable });
      return n;
    })(T())),
    (v = (t, e) => {
      t = localStorage.getItem(t);
      if (!t) return e;
      try {
        return JSON.parse(t);
      } catch (e) {
        return t;
      }
    }),
    (Q = (e) => {
      if (3 === e.length)
        e = e
          .split('')
          .map((e) => e + e)
          .join('');
      else {
        if (6 != e.length) throw 'Only 3- or 6-digit hex colours are allowed.';
        if (e.match(/[^0-9a-f]/i)) throw 'Only hex colours are allowed.';
      }
      e = e.match(/.{1,2}/g);
      if (e && 3 === e.length) return [parseInt(e[0], 16), parseInt(e[1], 16), parseInt(e[2], 16)];
      throw 'Could not parse hex colour.';
    }),
    (y = (e, t) => {
      let r = [];
      return (
        e && 0 < e.length
          ? (r = e.map((e) => ({ name: e.name, url: oe(e.url) })))
          : r.push({ name: t, url: 'https://github.com/' + t }),
        r
      );
    }),
    (ee = (...e) => {
      console.debug('Resetting Marketplace');
      const t = [];
      0 === e.length &&
        Object.keys(localStorage).forEach((e) => {
          e.startsWith('marketplace:') && t.push(e);
        }),
        e.forEach((e) => {
          switch (e) {
            case 'extensions':
              t.push(...v(g.installedExtensions, [])), t.push(g.installedExtensions);
              break;
            case 'snippets':
              t.push(...v(g.installedSnippets, [])), t.push(g.installedSnippets);
              break;
            case 'theme':
              t.push(...v(g.installedThemes, [])), t.push(g.installedThemes), t.push(g.themeInstalled);
              break;
            default:
              console.error('Unknown category: ' + e);
          }
        }),
        t.forEach((e) => {
          localStorage.removeItem(e), console.debug('Removed ' + e);
        }),
        console.debug('Marketplace has been reset'),
        location.reload();
    }),
    (te = () => {
      const t = {};
      return (
        Object.keys(localStorage).forEach((e) => {
          e.startsWith('marketplace:') && (t[e] = localStorage.getItem(e));
        }),
        t
      );
    }),
    (w = (r) => {
      var e = document.querySelector('style.marketplaceCSS.marketplaceScheme');
      if ((e && e.remove(), r)) {
        e = document.createElement('style');
        e.classList.add('marketplaceCSS'), e.classList.add('marketplaceScheme');
        let t = ':root {';
        Object.keys(r).forEach((e) => {
          t = (t += `--spice-${e}: #${r[e]};`) + `--spice-rgb-${e}: ${Q(r[e])};`;
        }),
          (t += '}'),
          (e.innerHTML = t),
          document.body.appendChild(e);
      }
    }),
    (re = async (e) => {
      let t = v(g.albumArtBasedColorVibrancy);
      return (t = t.replace(/([A-Z])/g, '_$1').toUpperCase()), (await Spicetify.colorExtractor(e))[t].substring(1);
    }),
    (ne = async (e, t) => {
      var r = v(g.albumArtBasedColorMode)
        .replace(/([A-Z])/g, '-$1')
        .toLowerCase();
      return (
        await fetch(`https://www.thecolorapi.com/scheme?hex=${e}&mode=${r}&count=` + t).then((e) => e.json())
      ).colors.map((e) => e.hex.value.substring(1));
    }),
    (ae = (h) => {
      Spicetify.Player.addEventListener('songchange', async () => {
        var t;
        (t = 1e3), await new Promise((e) => setTimeout(e, t));
        let r = Spicetify.Player.data?.item?.metadata?.image_xlarge_url;
        if (
          (r =
            null == r
              ? await new Promise((t) => {
                  setInterval(() => {
                    var e = Spicetify.Player.data?.item?.metadata?.image_xlarge_url;
                    e && t(e);
                  }, 50);
                })
              : r)
        ) {
          var n,
            a,
            o = new Set(Object.values(h)).size,
            s = await re(r),
            i = await ne(s, o);
          let e = new Map();
          for ([n, a] of Object.entries(h)) e.has(a) ? e.get(a).push(n) : e.set(a, [n]);
          var l,
            s = new Map(
              [...e.entries()].sort((e, t) => {
                (e = (0, m.default)(e[0])), (t = (0, m.default)(t[0]));
                return e.get('lab.l') - t.get('lab.l');
              }),
            ),
            u = {};
          for ([, l] of (e = s).entries()) {
            var c = i.shift();
            if (c) for (const f of l) u[f] = c;
          }
          w(u);
        }
      });
    }),
    (k = (e) => {
      e = new URL(e);
      return e.host, 'raw.githubusercontent.com' === e.host;
    }),
    (x = (e) => {
      e = e.match(
        /https:\/\/raw\.githubusercontent\.com\/(?<user>[^/]+)\/(?<repo>[^/]+)\/(?<branch>[^/]+)\/(?<filePath>.+$)/,
      );
      return {
        user: e ? e.groups?.user : null,
        repo: e ? e.groups?.repo : null,
        branch: e ? e.groups?.branch : null,
        filePath: e ? e.groups?.filePath : null,
      };
    }),
    (oe = (e) => {
      var t = decodeURI(e).trim().toLowerCase();
      return t.startsWith('javascript:') || t.startsWith('data:') || t.startsWith('vbscript:') ? 'about:blank' : e;
    }),
    (S = (e) => {
      e &&
        (e = e.split('/').pop()) &&
        -1 === Spicetify.Config.extensions.indexOf(e) &&
        Spicetify.Config.extensions.push(e);
    }),
    (n = new Blob(
      [
        `
  self.addEventListener('message', async (event) => {
    const url = event.data;
    const response = await fetch(url);
    const data = await response.json().catch(() => null);
    self.postMessage(data);
  });
`,
      ],
      { type: 'application/javascript' },
    )),
    (se = URL.createObjectURL(n)),
    (async function e() {
      if (Spicetify.LocalStorage && Spicetify.showNotification) {
        var t = document.createElement('script');
        (t.innerHTML = 'const global = globalThis;'),
          document.body.appendChild(t),
          console.log('Initializing Spicetify Marketplace v1.0.2'),
          (window.Marketplace = { reset: ee, export: te, version: '1.0.2' });
        const l = await xe();
        t = async (t) => {
          t = v(t);
          if (t) {
            if ((console.debug('Initializing theme: ', t), t.schemes)) {
              var e = t.schemes[t.activeScheme];
              if (
                (w(e),
                (Spicetify.Config.color_scheme = t.activeScheme),
                'true' === localStorage.getItem(g.albumArtBasedColor))
              )
                ae(e);
              else if ('true' === localStorage.getItem(g.colorShift)) {
                var r = t.schemes;
                let e = 0;
                const i = Object.keys(r).length;
                setInterval(() => {
                  (e %= i), w(Object.values(r)[e]), e++;
                }, 6e4);
              }
            } else console.warn('No schemes found for theme');
            (e = document.querySelector('link.marketplaceCSS')),
              (e =
                (e && e.remove(),
                await (async (e, t) => {
                  if (!e.cssURL) throw new Error('No CSS URL provided');
                  t ||= await xe();
                  var t = k(e.cssURL)
                      ? `https://cdn.jsdelivr.${t}/gh/${e.user}/${e.repo}@${e.branch}/` + e.manifest.usercss
                      : e.cssURL,
                    r = t.replace('/user.css', '/assets/');
                  console.debug('Parsing CSS: ', t);
                  let n = await fetch(t + '?time=' + Date.now()).then((e) => e.text());
                  for (const s of n.matchAll(/url\(['|"](?<path>.+?)['|"]\)/gm) || []) {
                    var a,
                      o = s?.groups?.path;
                    !o ||
                      o.startsWith('http') ||
                      o.startsWith('data') ||
                      ((a = r + o.replace(/\.\//g, '')), (n = n.replace(o, a)));
                  }
                  return n;
                })(t, l)));
            try {
              var n,
                a,
                o = document.querySelector("link[href='user.css']"),
                s = (o && o.remove(), document.querySelector('style.marketplaceCSS.marketplaceUserCSS'));
              s && s.remove(),
                e
                  ? ((n = document.createElement('style')).classList.add('marketplaceCSS'),
                    n.classList.add('marketplaceUserCSS'),
                    (n.innerHTML = e),
                    document.body.appendChild(n))
                  : ((a = document.createElement('link')).setAttribute('rel', 'stylesheet'),
                    a.setAttribute('href', 'user.css'),
                    a.classList.add('userCSS'),
                    document.body.appendChild(a));
            } catch (e) {
              console.warn(e);
            }
            (Spicetify.Config.current_theme = t.manifest?.name),
              t.include &&
                t.include.length &&
                t.include.forEach((e) => {
                  var t = document.createElement('script');
                  let r = e;
                  if (k(e)) {
                    var { user: n, repo: a, branch: o, filePath: s } = x(e);
                    if (!(n && a && o && s)) return;
                    (r = `https://cdn.jsdelivr.${l}/gh/${n}/${a}@${o}/` + s), s.endsWith('.mjs') && (t.type = 'module');
                  }
                  (t.src = r + '?time=' + Date.now()),
                    t.classList.add('marketplaceScript'),
                    document.body.appendChild(t),
                    S(e);
                });
          } else console.debug('No theme manifest found');
        };
        console.log('Loaded Marketplace extension');
        var r,
          n = v(g.installedSnippets, []).map((e) => v(e));
        (n = n),
          (r = document.querySelector('style.marketplaceSnippets')) && r.remove(),
          (r = document.createElement('style')),
          (n = n.reduce(
            (e, t) =>
              (e =
                (e += `/* ${t.title} - ${t.description} */
`) +
                t.code +
                `
`),
            '',
          )),
          (r.innerHTML = n),
          r.classList.add('marketplaceSnippets'),
          document.body.appendChild(r),
          l
            ? (window.sessionStorage.setItem('marketplace-request-tld', l),
              (n = (v(g.installedExtensions, []).forEach((e) => {
                if ((e = v(e)) && e.extensionURL) {
                  console.debug('Initializing extension: ', e);
                  var t = document.createElement('script');
                  if (((t.defer = !0), (t.src = e.extensionURL), k(t.src))) {
                    var { user: r, repo: n, branch: a, filePath: o } = x(e.extensionURL);
                    if (!(r && n && a && o)) return;
                    (t.src = `https://cdn.jsdelivr.${l}/gh/${r}/${n}@${a}/` + o),
                      o.endsWith('.mjs') && (t.type = 'module');
                  }
                  (t.src = t.src + '?time=' + Date.now()), document.body.appendChild(t), S(e.manifest?.main);
                }
              }),
              Spicetify.Config)['current_theme']),
              localStorage.setItem(g.localTheme, n),
              (r = localStorage.getItem(g.themeInstalled)) &&
                ('marketplace' !== n.toLocaleLowerCase()
                  ? Spicetify.showNotification(d('notifications.wrongLocalTheme'), !0, 5e3)
                  : t(r)))
            : window.navigator.onLine
              ? (console.error(new Error('Unable to connect to the CDN, please check your Internet configuration.')),
                Spicetify.showNotification(d('notifications.noCdnConnection'), !0, 5e3))
              : window.addEventListener('online', e, { once: !0 });
      } else setTimeout(e, 100);
    })(),
    (async function () {
      console.debug('Preloading extensions and themes...'), window.sessionStorage.clear();
      var e = await (
        await fetch('https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/blacklist.json')
          .then((e) => e.json())
          .catch(() => ({}))
      ).repos;
      window.sessionStorage.setItem('marketplace:blacklist', JSON.stringify(e)),
        await Promise.all([A('extension', 0), A('theme', 0), A('app', 0)]);
    })();
  function L() {
    let r, n;
    var e = new Promise((e, t) => {
      (r = e), (n = t);
    });
    return (e.resolve = r), (e.reject = n), e;
  }
  function ie(e) {
    return null == e ? '' : '' + e;
  }
  function le(e, t, r) {
    e.forEach((e) => {
      t[e] && (r[e] = t[e]);
    });
  }
  function O(e, t, r) {
    function n(e) {
      return e && -1 < e.indexOf('###') ? e.replace(V, '.') : e;
    }
    function a() {
      return !e || 'string' == typeof e;
    }
    var o = 'string' != typeof t ? t : t.split('.');
    let s = 0;
    for (; s < o.length - 1; ) {
      if (a()) return {};
      var i = n(o[s]);
      !e[i] && r && (e[i] = new r()), (e = Object.prototype.hasOwnProperty.call(e, i) ? e[i] : {}), ++s;
    }
    return a() ? {} : { obj: e, k: n(o[s]) };
  }
  function ue(n, a, o) {
    var { obj: e, k: t } = O(n, a, Object);
    if (void 0 !== e || 1 === a.length) e[t] = o;
    else {
      let e = a[a.length - 1],
        t = a.slice(0, a.length - 1),
        r = O(n, t, Object);
      for (; void 0 === r.obj && t.length; )
        (e = t[t.length - 1] + '.' + e),
          (t = t.slice(0, t.length - 1)),
          (r = O(n, t, Object)) && r.obj && void 0 !== r.obj[r.k + '.' + e] && (r.obj = void 0);
      r.obj[r.k + '.' + e] = o;
    }
  }
  function ce(e, t, r, n) {
    var { obj: e, k: t } = O(e, t, Object);
    (e[t] = e[t] || []), n && (e[t] = e[t].concat(r)), n || e[t].push(r);
  }
  function N(e, t) {
    var { obj: e, k: t } = O(e, t);
    if (e) return e[t];
  }
  function fe(e, t, r) {
    for (const n in t)
      '__proto__' !== n &&
        'constructor' !== n &&
        (n in e
          ? 'string' == typeof e[n] || e[n] instanceof String || 'string' == typeof t[n] || t[n] instanceof String
            ? r && (e[n] = t[n])
            : fe(e[n], t[n], r)
          : (e[n] = t[n]));
  }
  function R(e) {
    return e.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, '\\$&');
  }
  function he(e) {
    return 'string' == typeof e ? e.replace(/[&<>"'\/]/g, (e) => B[e]) : e;
  }
  function pe(e, t, r) {
    (t = t || ''), (r = r || '');
    var n = q.filter((e) => t.indexOf(e) < 0 && r.indexOf(e) < 0);
    if (0 === n.length) return 1;
    var a,
      n = z.getRegExp(`(${n.map((e) => ('?' === e ? '\\?' : e)).join('|')})`);
    let o = !n.test(e);
    return o || (0 < (a = e.indexOf(r)) && !n.test(e.substring(0, a)) && (o = !0)), o;
  }
  function P(e, t, r) {
    var o = 2 < arguments.length && void 0 !== r ? r : '.';
    if (e) {
      if (e[t]) return e[t];
      var s = t.split(o);
      let a = e;
      for (let n = 0; n < s.length; ) {
        if (!a || 'object' != typeof a) return;
        let t,
          r = '';
        for (let e = n; e < s.length; ++e)
          if (
            (e !== n && (r += o),
            (r += s[e]),
            void 0 !== (t = a[r]) && !(-1 < ['string', 'number', 'boolean'].indexOf(typeof t) && e < s.length - 1))
          ) {
            n += e - n + 1;
            break;
          }
        a = t;
      }
      return a;
    }
  }
  function j(e) {
    return e && 0 < e.indexOf('_') ? e.replace('_', '-') : e;
  }
  function M(e) {
    return e.charAt(0).toUpperCase() + e.slice(1);
  }
  function de() {
    const r = {};
    return (
      K.forEach((t) => {
        t.lngs.forEach((e) => {
          r[e] = { numbers: t.nr, plurals: H[t.fc] };
        });
      }),
      r
    );
  }
  function ge(e, t, r, n, a) {
    var o,
      s,
      i,
      l = 3 < arguments.length && void 0 !== n ? n : '.',
      u = !(4 < arguments.length && void 0 !== a) || a;
    s = t;
    let c = void 0 !== (o = N((o = e), (i = r))) ? o : N(s, i);
    return (c = !c && u && 'string' == typeof r && void 0 === (c = P(e, r, l)) ? P(t, r, l) : c);
  }
  function be(e) {
    let t = e.toLowerCase().trim();
    const r = {};
    return (
      -1 < e.indexOf('(') &&
        ((e = e.split('(')),
        (t = e[0].toLowerCase().trim()),
        (e = e[1].substring(0, e[1].length - 1)),
        'currency' === t && e.indexOf(':') < 0
          ? r.currency || (r.currency = e.trim())
          : 'relativetime' === t && e.indexOf(':') < 0
            ? r.range || (r.range = e.trim())
            : e.split(';').forEach((e) => {
                var t;
                e &&
                  (([e, ...t] = e.split(':')),
                  (t = t
                    .join(':')
                    .trim()
                    .replace(/^'+|'+$/g, '')),
                  r[e.trim()] || (r[e.trim()] = t),
                  'false' === t && (r[e.trim()] = !1),
                  'true' === t && (r[e.trim()] = !0),
                  isNaN(t) || (r[e.trim()] = parseInt(t, 10)));
              })),
      { formatName: t, formatOptions: r }
    );
  }
  function E(o) {
    const s = {};
    return function (e, t, r) {
      var n = t + JSON.stringify(r);
      let a = s[n];
      return a || ((a = o(j(t), r)), (s[n] = a)), a(e);
    };
  }
  function me(e, t) {
    void 0 !== e.pending[t] && (delete e.pending[t], e.pendingCount--);
  }
  function ve() {
    return {
      debug: !1,
      initImmediate: !0,
      ns: ['translation'],
      defaultNS: ['translation'],
      fallbackLng: ['dev'],
      fallbackNS: !1,
      supportedLngs: !1,
      nonExplicitSupportedLngs: !1,
      load: 'all',
      preload: !1,
      simplifyPluralSuffix: !0,
      keySeparator: '.',
      nsSeparator: ':',
      pluralSeparator: '_',
      contextSeparator: '_',
      partialBundledLanguages: !1,
      saveMissing: !1,
      updateMissing: !1,
      saveMissingTo: 'fallback',
      saveMissingPlurals: !0,
      missingKeyHandler: !1,
      missingInterpolationHandler: !1,
      postProcess: !1,
      postProcessPassResolved: !1,
      returnNull: !1,
      returnEmptyString: !0,
      returnObjects: !1,
      joinArrays: !1,
      returnedObjectHandler: !1,
      parseMissingKeyHandler: !1,
      appendNamespaceToMissingKey: !1,
      appendNamespaceToCIMode: !1,
      overloadTranslationOptionHandler: function (e) {
        let t = {};
        if (
          ('object' == typeof e[1] && (t = e[1]),
          'string' == typeof e[1] && (t.defaultValue = e[1]),
          'string' == typeof e[2] && (t.tDescription = e[2]),
          'object' == typeof e[2] || 'object' == typeof e[3])
        ) {
          const r = e[3] || e[2];
          Object.keys(r).forEach((e) => {
            t[e] = r[e];
          });
        }
        return t;
      },
      interpolation: {
        escapeValue: !0,
        format: (e) => e,
        prefix: '{{',
        suffix: '}}',
        formatSeparator: ',',
        unescapePrefix: '-',
        nestingPrefix: '$t(',
        nestingSuffix: ')',
        nestingOptionsSeparator: ',',
        maxReplaces: 1e3,
        skipOnVariables: !0,
      },
    };
  }
  function ye(e) {
    return (
      'string' == typeof e.ns && (e.ns = [e.ns]),
      'string' == typeof e.fallbackLng && (e.fallbackLng = [e.fallbackLng]),
      'string' == typeof e.fallbackNS && (e.fallbackNS = [e.fallbackNS]),
      e.supportedLngs &&
        e.supportedLngs.indexOf('cimode') < 0 &&
        (e.supportedLngs = e.supportedLngs.concat(['cimode'])),
      e
    );
  }
  function I() {}
  function we(t) {
    Object.getOwnPropertyNames(Object.getPrototypeOf(t)).forEach((e) => {
      'function' == typeof t[e] && (t[e] = t[e].bind(t));
    });
  }
  function ke(e, n) {
    e &&
      e.forEach((e) => {
        var t = n || e.user + '-' + e.repo,
          r = window.sessionStorage.getItem(t),
          r = r ? JSON.parse(r) : [];
        r.push(e), window.sessionStorage.setItem(t, JSON.stringify(r));
      });
  }
  async function xe() {
    for (const e of ['net', 'xyz'])
      try {
        if (
          'opaqueredirect' ===
          (await fetch('https://cdn.jsdelivr.' + e, { redirect: 'manual', cache: 'no-cache' })).type
        )
          return e;
      } catch (e) {
        console.error(e);
        continue;
      }
  }
  async function $(e, t, r) {
    var n = e + '-' + t,
      a = window.sessionStorage.getItem(n),
      o = JSON.parse(window.sessionStorage.getItem('noManifests') || '[]');
    if (a) return JSON.parse(a);
    a = `https://raw.githubusercontent.com/${e}/${t}/${r}/manifest.json`;
    if (o.includes(a)) return null;
    let s = await (async function (e) {
      const n = new Worker(se);
      return new Promise((t) => {
        const r = (e) => {
          n.terminate(), t(e);
        };
        n.postMessage(e),
          n.addEventListener('message', (e) => r(e.data), { once: !0 }),
          n.addEventListener('error', () => r(null), { once: !0 });
      });
    })(a);
    return s ? (ke((s = Array.isArray(s) ? s : [s]), n), s) : ke([a], 'noManifests');
  }
  async function A(e, t) {
    var r = await (async function (e, t = 1) {
        const r = window.sessionStorage.getItem('marketplace:blacklist');
        let n =
          `https://api.github.com/search/repositories?per_page=${b}&q=` + encodeURIComponent(`topic:spicetify-${e}s`);
        t && (n += '&page=' + t);
        var a =
          JSON.parse(window.sessionStorage.getItem(`spicetify-${e}s-page-` + t) || 'null') ||
          (await fetch(n)
            .then((e) => e.json())
            .catch(() => null));
        return a?.items
          ? (window.sessionStorage.setItem(`spicetify-${e}s-page-` + t, JSON.stringify(a)),
            { ...a, page_count: a.items.length, items: a.items.filter((e) => !r?.includes(e.html_url)) })
          : (Spicetify.showNotification(d('notifications.tooManyRequests'), !0, 5e3), { items: [] });
      })(e, t),
      n =
        (!(async function (e, t) {
          for (const r of e.items)
            'theme' === t
              ? await (async function (e, n, a) {
                  try {
                    var t = e.match(/https:\/\/api\.github\.com\/repos\/(?<user>.+)\/(?<repo>.+)\/contents/);
                    if (!t || !t.groups) return;
                    const { user: o, repo: s } = t.groups;
                    return (await $(o, s, n)).reduce((e, t) => {
                      var r = t.branch || n,
                        r = {
                          manifest: t,
                          title: t.name,
                          subtitle: t.description,
                          authors: y(t.authors, o),
                          user: o,
                          repo: s,
                          branch: r,
                          imageURL:
                            t.preview && t.preview.startsWith('http')
                              ? t.preview
                              : `https://raw.githubusercontent.com/${o}/${s}/${r}/` + t.preview,
                          readmeURL:
                            t.readme && t.readme.startsWith('http')
                              ? t.readme
                              : `https://raw.githubusercontent.com/${o}/${s}/${r}/` + t.readme,
                          stars: a,
                          tags: t.tags,
                          cssURL: t.usercss.startsWith('http')
                            ? t.usercss
                            : `https://raw.githubusercontent.com/${o}/${s}/${r}/` + t.usercss,
                          schemesURL: t.schemes
                            ? t.schemes.startsWith('http')
                              ? t.schemes
                              : `https://raw.githubusercontent.com/${o}/${s}/${r}/` + t.schemes
                            : null,
                          include: t.include,
                        };
                      return t?.name && t?.usercss && t?.description && e.push(r), e;
                    }, []);
                  } catch {
                    return;
                  }
                })(r.contents_url, r.default_branch, r.stargazers_count)
              : 'extension' === t
                ? await (async function (e, n, a, o = !1) {
                    try {
                      var t = e.match(/https:\/\/api\.github\.com\/repos\/(?<user>.+)\/(?<repo>.+)\/contents/);
                      if (!t || !t.groups) return;
                      const { user: s, repo: i } = t.groups;
                      return (await $(s, i, n)).reduce((e, t) => {
                        var r = t.branch || n,
                          r = {
                            manifest: t,
                            title: t.name,
                            subtitle: t.description,
                            authors: y(t.authors, s),
                            user: s,
                            repo: i,
                            branch: r,
                            imageURL:
                              t.preview && t.preview.startsWith('http')
                                ? t.preview
                                : `https://raw.githubusercontent.com/${s}/${i}/${r}/` + t.preview,
                            extensionURL: t.main.startsWith('http')
                              ? t.main
                              : `https://raw.githubusercontent.com/${s}/${i}/${r}/` + t.main,
                            readmeURL:
                              t.readme && t.readme.startsWith('http')
                                ? t.readme
                                : `https://raw.githubusercontent.com/${s}/${i}/${r}/` + t.readme,
                            stars: a,
                            tags: t.tags,
                          };
                        return (
                          t &&
                            t.name &&
                            t.description &&
                            t.main &&
                            ((o && localStorage.getItem(`marketplace:installed:${s}/${i}/` + t.main)) || e.push(r)),
                          e
                        );
                      }, []);
                    } catch {
                      return;
                    }
                  })(r.contents_url, r.default_branch, r.stargazers_count)
                : 'app' === t &&
                  (await (async function (e, n, a) {
                    try {
                      var t = e.match(/https:\/\/api\.github\.com\/repos\/(?<user>.+)\/(?<repo>.+)\/contents/);
                      if (!t || !t.groups) return;
                      const { user: o, repo: s } = t.groups;
                      return (await $(o, s, n)).reduce((e, t) => {
                        var r = t.branch || n,
                          r = {
                            manifest: t,
                            title: t.name,
                            subtitle: t.description,
                            authors: y(t.authors, o),
                            user: o,
                            repo: s,
                            branch: r,
                            imageURL:
                              t.preview && t.preview.startsWith('http')
                                ? t.preview
                                : `https://raw.githubusercontent.com/${o}/${s}/${r}/` + t.preview,
                            readmeURL:
                              t.readme && t.readme.startsWith('http')
                                ? t.readme
                                : `https://raw.githubusercontent.com/${o}/${s}/${r}/` + t.readme,
                            stars: a,
                            tags: t.tags,
                          };
                        return t && t.name && t.description && e.push(r), e;
                      }, []);
                    } catch {
                      return;
                    }
                  })(r.contents_url, r.default_branch, r.stargazers_count));
        })(r, e),
        b * t + r.page_count),
      a = (console.debug({ pageOfRepos: r }), r.total_count - n);
    if ((console.debug(`Parsed ${n}/${r.total_count} ${e}s`), 0 < a)) return A(e, t + 1);
    console.debug(`No more ${e} results`);
  }
})();
