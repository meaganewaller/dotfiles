var marketplace = (() => {
  var A,
    P = Object.create,
    M = Object.defineProperty,
    _ = Object.getOwnPropertyDescriptor,
    R = Object.getOwnPropertyNames,
    j = Object.getPrototypeOf,
    D = Object.prototype.hasOwnProperty,
    e = (e, t) =>
      function () {
        return t || (0, e[R(e)[0]])((t = { exports: {} }).exports, t), t.exports;
      },
    $ = (t, a, r, n) => {
      if ((a && 'object' == typeof a) || 'function' == typeof a)
        for (let e of R(a))
          D.call(t, e) || e === r || M(t, e, { get: () => a[e], enumerable: !(n = _(a, e)) || n.enumerable });
      return t;
    },
    t = (e, t, a) => (
      (a = null != e ? P(j(e)) : {}), $(!t && e && e.__esModule ? a : M(a, 'default', { value: e, enumerable: !0 }), e)
    ),
    b = e({
      'external-global-plugin:react'(e, t) {
        t.exports = Spicetify.React;
      },
    }),
    z = e({
      'node_modules/.pnpm/void-elements@3.1.0/node_modules/void-elements/index.js'(e, t) {
        t.exports = {
          area: !0,
          base: !0,
          br: !0,
          col: !0,
          embed: !0,
          hr: !0,
          img: !0,
          input: !0,
          link: !0,
          meta: !0,
          param: !0,
          source: !0,
          track: !0,
          wbr: !0,
        };
      },
    }),
    J = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/internal/constants.js'(e, t) {
        var a = Number.MAX_SAFE_INTEGER || 9007199254740991;
        t.exports = {
          MAX_LENGTH: 256,
          MAX_SAFE_COMPONENT_LENGTH: 16,
          MAX_SAFE_BUILD_LENGTH: 250,
          MAX_SAFE_INTEGER: a,
          RELEASE_TYPES: ['major', 'premajor', 'minor', 'preminor', 'patch', 'prepatch', 'prerelease'],
          SEMVER_SPEC_VERSION: '2.0.0',
          FLAG_INCLUDE_PRERELEASE: 1,
          FLAG_LOOSE: 2,
        };
      },
    }),
    U = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/internal/debug.js'(e, t) {
        var a =
          'object' == typeof process &&
          process.env &&
          process.env.NODE_DEBUG &&
          /\bsemver\b/i.test(process.env.NODE_DEBUG)
            ? (...e) => console.error('SEMVER', ...e)
            : () => {};
        t.exports = a;
      },
    }),
    V = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/internal/re.js'(e, t) {
        var { MAX_SAFE_COMPONENT_LENGTH: a, MAX_SAFE_BUILD_LENGTH: r, MAX_LENGTH: n } = J(),
          o = U(),
          i = ((e = t.exports = {}).re = []),
          s = (e.safeRe = []),
          l = (e.src = []),
          c = (e.t = {}),
          u = 0,
          t = '[a-zA-Z0-9-]',
          d = [
            ['\\s', 1],
            ['\\d', n],
            [t, r],
          ],
          n = (e, t, a) => {
            var r = ((e) => {
                for (var [t, a] of d)
                  e = e
                    .split(t + '*')
                    .join(`${t}{0,${a}}`)
                    .split(t + '+')
                    .join(`${t}{1,${a}}`);
                return e;
              })(t),
              n = u++;
            o(e, n, t),
              (c[e] = n),
              (l[n] = t),
              (i[n] = new RegExp(t, a ? 'g' : void 0)),
              (s[n] = new RegExp(r, a ? 'g' : void 0));
          };
        n('NUMERICIDENTIFIER', '0|[1-9]\\d*'),
          n('NUMERICIDENTIFIERLOOSE', '\\d+'),
          n('NONNUMERICIDENTIFIER', `\\d*[a-zA-Z-]${t}*`),
          n('MAINVERSION', `(${l[c.NUMERICIDENTIFIER]})\\.(${l[c.NUMERICIDENTIFIER]})\\.(${l[c.NUMERICIDENTIFIER]})`),
          n(
            'MAINVERSIONLOOSE',
            `(${l[c.NUMERICIDENTIFIERLOOSE]})\\.(${l[c.NUMERICIDENTIFIERLOOSE]})\\.(${l[c.NUMERICIDENTIFIERLOOSE]})`,
          ),
          n('PRERELEASEIDENTIFIER', `(?:${l[c.NUMERICIDENTIFIER]}|${l[c.NONNUMERICIDENTIFIER]})`),
          n('PRERELEASEIDENTIFIERLOOSE', `(?:${l[c.NUMERICIDENTIFIERLOOSE]}|${l[c.NONNUMERICIDENTIFIER]})`),
          n('PRERELEASE', `(?:-(${l[c.PRERELEASEIDENTIFIER]}(?:\\.${l[c.PRERELEASEIDENTIFIER]})*))`),
          n('PRERELEASELOOSE', `(?:-?(${l[c.PRERELEASEIDENTIFIERLOOSE]}(?:\\.${l[c.PRERELEASEIDENTIFIERLOOSE]})*))`),
          n('BUILDIDENTIFIER', t + '+'),
          n('BUILD', `(?:\\+(${l[c.BUILDIDENTIFIER]}(?:\\.${l[c.BUILDIDENTIFIER]})*))`),
          n('FULLPLAIN', `v?${l[c.MAINVERSION]}${l[c.PRERELEASE]}?${l[c.BUILD]}?`),
          n('FULL', `^${l[c.FULLPLAIN]}$`),
          n('LOOSEPLAIN', `[v=\\s]*${l[c.MAINVERSIONLOOSE]}${l[c.PRERELEASELOOSE]}?${l[c.BUILD]}?`),
          n('LOOSE', `^${l[c.LOOSEPLAIN]}$`),
          n('GTLT', '((?:<|>)?=?)'),
          n('XRANGEIDENTIFIERLOOSE', l[c.NUMERICIDENTIFIERLOOSE] + '|x|X|\\*'),
          n('XRANGEIDENTIFIER', l[c.NUMERICIDENTIFIER] + '|x|X|\\*'),
          n(
            'XRANGEPLAIN',
            `[v=\\s]*(${l[c.XRANGEIDENTIFIER]})(?:\\.(${l[c.XRANGEIDENTIFIER]})(?:\\.(${l[c.XRANGEIDENTIFIER]})(?:${l[c.PRERELEASE]})?${l[c.BUILD]}?)?)?`,
          ),
          n(
            'XRANGEPLAINLOOSE',
            `[v=\\s]*(${l[c.XRANGEIDENTIFIERLOOSE]})(?:\\.(${l[c.XRANGEIDENTIFIERLOOSE]})(?:\\.(${l[c.XRANGEIDENTIFIERLOOSE]})(?:${l[c.PRERELEASELOOSE]})?${l[c.BUILD]}?)?)?`,
          ),
          n('XRANGE', `^${l[c.GTLT]}\\s*${l[c.XRANGEPLAIN]}$`),
          n('XRANGELOOSE', `^${l[c.GTLT]}\\s*${l[c.XRANGEPLAINLOOSE]}$`),
          n('COERCEPLAIN', `(^|[^\\d])(\\d{1,${a}})(?:\\.(\\d{1,${a}}))?(?:\\.(\\d{1,${a}}))?`),
          n('COERCE', l[c.COERCEPLAIN] + '(?:$|[^\\d])'),
          n('COERCEFULL', l[c.COERCEPLAIN] + `(?:${l[c.PRERELEASE]})?(?:${l[c.BUILD]})?(?:$|[^\\d])`),
          n('COERCERTL', l[c.COERCE], !0),
          n('COERCERTLFULL', l[c.COERCEFULL], !0),
          n('LONETILDE', '(?:~>?)'),
          n('TILDETRIM', `(\\s*)${l[c.LONETILDE]}\\s+`, !0),
          (e.tildeTrimReplace = '$1~'),
          n('TILDE', `^${l[c.LONETILDE]}${l[c.XRANGEPLAIN]}$`),
          n('TILDELOOSE', `^${l[c.LONETILDE]}${l[c.XRANGEPLAINLOOSE]}$`),
          n('LONECARET', '(?:\\^)'),
          n('CARETTRIM', `(\\s*)${l[c.LONECARET]}\\s+`, !0),
          (e.caretTrimReplace = '$1^'),
          n('CARET', `^${l[c.LONECARET]}${l[c.XRANGEPLAIN]}$`),
          n('CARETLOOSE', `^${l[c.LONECARET]}${l[c.XRANGEPLAINLOOSE]}$`),
          n('COMPARATORLOOSE', `^${l[c.GTLT]}\\s*(${l[c.LOOSEPLAIN]})$|^$`),
          n('COMPARATOR', `^${l[c.GTLT]}\\s*(${l[c.FULLPLAIN]})$|^$`),
          n('COMPARATORTRIM', `(\\s*)${l[c.GTLT]}\\s*(${l[c.LOOSEPLAIN]}|${l[c.XRANGEPLAIN]})`, !0),
          (e.comparatorTrimReplace = '$1$2$3'),
          n('HYPHENRANGE', `^\\s*(${l[c.XRANGEPLAIN]})\\s+-\\s+(${l[c.XRANGEPLAIN]})\\s*$`),
          n('HYPHENRANGELOOSE', `^\\s*(${l[c.XRANGEPLAINLOOSE]})\\s+-\\s+(${l[c.XRANGEPLAINLOOSE]})\\s*$`),
          n('STAR', '(<|>)?=?\\s*\\*'),
          n('GTE0', '^\\s*>=\\s*0\\.0\\.0\\s*$'),
          n('GTE0PRE', '^\\s*>=\\s*0\\.0\\.0-0\\s*$');
      },
    }),
    B = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/internal/parse-options.js'(e, t) {
        var a = Object.freeze({ loose: !0 }),
          r = Object.freeze({});
        t.exports = (e) => (e ? ('object' != typeof e ? a : e) : r);
      },
    }),
    W = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/internal/identifiers.js'(e, t) {
        var n = /^[0-9]+$/,
          a = (e, t) => {
            var a = n.test(e),
              r = n.test(t);
            return a && r && ((e = +e), (t = +t)), e === t ? 0 : (a && !r) || ((!r || a) && e < t) ? -1 : 1;
          };
        t.exports = { compareIdentifiers: a, rcompareIdentifiers: (e, t) => a(t, e) };
      },
    }),
    H = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/classes/semver.js'(e, t) {
        var n = U(),
          { MAX_LENGTH: a, MAX_SAFE_INTEGER: r } = J(),
          { safeRe: o, t: i } = V(),
          s = B(),
          l = W()['compareIdentifiers'],
          c = class {
            constructor(e, t) {
              if (((t = s(t)), e instanceof c)) {
                if (e.loose === !!t.loose && e.includePrerelease === !!t.includePrerelease) return e;
                e = e.version;
              } else if ('string' != typeof e)
                throw new TypeError(`Invalid version. Must be a string. Got type "${typeof e}".`);
              if (e.length > a) throw new TypeError(`version is longer than ${a} characters`);
              n('SemVer', e, t),
                (this.options = t),
                (this.loose = !!t.loose),
                (this.includePrerelease = !!t.includePrerelease);
              t = e.trim().match(t.loose ? o[i.LOOSE] : o[i.FULL]);
              if (!t) throw new TypeError('Invalid Version: ' + e);
              if (
                ((this.raw = e),
                (this.major = +t[1]),
                (this.minor = +t[2]),
                (this.patch = +t[3]),
                this.major > r || this.major < 0)
              )
                throw new TypeError('Invalid major version');
              if (this.minor > r || this.minor < 0) throw new TypeError('Invalid minor version');
              if (this.patch > r || this.patch < 0) throw new TypeError('Invalid patch version');
              t[4]
                ? (this.prerelease = t[4].split('.').map((e) => {
                    if (/^[0-9]+$/.test(e)) {
                      var t = +e;
                      if (0 <= t && t < r) return t;
                    }
                    return e;
                  }))
                : (this.prerelease = []),
                (this.build = t[5] ? t[5].split('.') : []),
                this.format();
            }
            format() {
              return (
                (this.version = `${this.major}.${this.minor}.` + this.patch),
                this.prerelease.length && (this.version += '-' + this.prerelease.join('.')),
                this.version
              );
            }
            toString() {
              return this.version;
            }
            compare(e) {
              if ((n('SemVer.compare', this.version, this.options, e), !(e instanceof c))) {
                if ('string' == typeof e && e === this.version) return 0;
                e = new c(e, this.options);
              }
              return e.version === this.version ? 0 : this.compareMain(e) || this.comparePre(e);
            }
            compareMain(e) {
              return (
                e instanceof c || (e = new c(e, this.options)),
                l(this.major, e.major) || l(this.minor, e.minor) || l(this.patch, e.patch)
              );
            }
            comparePre(e) {
              if ((e instanceof c || (e = new c(e, this.options)), this.prerelease.length && !e.prerelease.length))
                return -1;
              if (!this.prerelease.length && e.prerelease.length) return 1;
              if (!this.prerelease.length && !e.prerelease.length) return 0;
              let t = 0;
              do {
                var a = this.prerelease[t],
                  r = e.prerelease[t];
                if ((n('prerelease compare', t, a, r), void 0 === a && void 0 === r)) return 0;
                if (void 0 === r) return 1;
                if (void 0 === a) return -1;
                if (a !== r) return l(a, r);
              } while (++t);
            }
            compareBuild(e) {
              e instanceof c || (e = new c(e, this.options));
              let t = 0;
              do {
                var a = this.build[t],
                  r = e.build[t];
                if ((n('prerelease compare', t, a, r), void 0 === a && void 0 === r)) return 0;
                if (void 0 === r) return 1;
                if (void 0 === a) return -1;
                if (a !== r) return l(a, r);
              } while (++t);
            }
            inc(e, t, a) {
              switch (e) {
                case 'premajor':
                  (this.prerelease.length = 0), (this.patch = 0), (this.minor = 0), this.major++, this.inc('pre', t, a);
                  break;
                case 'preminor':
                  (this.prerelease.length = 0), (this.patch = 0), this.minor++, this.inc('pre', t, a);
                  break;
                case 'prepatch':
                  (this.prerelease.length = 0), this.inc('patch', t, a), this.inc('pre', t, a);
                  break;
                case 'prerelease':
                  0 === this.prerelease.length && this.inc('patch', t, a), this.inc('pre', t, a);
                  break;
                case 'major':
                  (0 === this.minor && 0 === this.patch && 0 !== this.prerelease.length) || this.major++,
                    (this.minor = 0),
                    (this.patch = 0),
                    (this.prerelease = []);
                  break;
                case 'minor':
                  (0 === this.patch && 0 !== this.prerelease.length) || this.minor++,
                    (this.patch = 0),
                    (this.prerelease = []);
                  break;
                case 'patch':
                  0 === this.prerelease.length && this.patch++, (this.prerelease = []);
                  break;
                case 'pre':
                  var r = Number(a) ? 1 : 0;
                  if (!t && !1 === a) throw new Error('invalid increment argument: identifier is empty');
                  if (0 === this.prerelease.length) this.prerelease = [r];
                  else {
                    let e = this.prerelease.length;
                    for (; 0 <= --e; ) 'number' == typeof this.prerelease[e] && (this.prerelease[e]++, (e = -2));
                    if (-1 === e) {
                      if (t === this.prerelease.join('.') && !1 === a)
                        throw new Error('invalid increment argument: identifier already exists');
                      this.prerelease.push(r);
                    }
                  }
                  if (t) {
                    let e = !1 === a ? [t] : [t, r];
                    (0 !== l(this.prerelease[0], t) || isNaN(this.prerelease[1])) && (this.prerelease = e);
                  }
                  break;
                default:
                  throw new Error('invalid increment argument: ' + e);
              }
              return (this.raw = this.format()), this.build.length && (this.raw += '+' + this.build.join('.')), this;
            }
          };
        t.exports = c;
      },
    }),
    q = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/functions/parse.js'(e, t) {
        var r = H();
        t.exports = (e, t, a = !1) => {
          if (e instanceof r) return e;
          try {
            return new r(e, t);
          } catch (e) {
            if (a) throw e;
            return null;
          }
        };
      },
    }),
    Z = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/functions/valid.js'(e, t) {
        var a = q();
        t.exports = (e, t) => {
          e = a(e, t);
          return e ? e.version : null;
        };
      },
    }),
    X = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/functions/clean.js'(e, t) {
        var a = q();
        t.exports = (e, t) => {
          e = a(e.trim().replace(/^[=v]+/, ''), t);
          return e ? e.version : null;
        };
      },
    }),
    Y = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/functions/inc.js'(e, t) {
        var o = H();
        t.exports = (e, t, a, r, n) => {
          'string' == typeof a && ((n = r), (r = a), (a = void 0));
          try {
            return new o(e instanceof o ? e.version : e, a).inc(t, r, n).version;
          } catch (e) {
            return null;
          }
        };
      },
    }),
    Q = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/functions/diff.js'(e, t) {
        var o = q();
        t.exports = (e, t) => {
          var a,
            r,
            e = o(e, null, !0),
            t = o(t, null, !0),
            n = e.compare(t);
          return 0 === n
            ? null
            : ((r = !!(a = (n = 0 < n) ? e : t).prerelease.length),
              !!(n = n ? t : e).prerelease.length && !r
                ? n.patch || n.minor
                  ? a.patch
                    ? 'patch'
                    : a.minor
                      ? 'minor'
                      : 'major'
                  : 'major'
                : ((n = r ? 'pre' : ''),
                  e.major !== t.major
                    ? n + 'major'
                    : e.minor !== t.minor
                      ? n + 'minor'
                      : e.patch !== t.patch
                        ? n + 'patch'
                        : 'prerelease'));
        };
      },
    }),
    ee = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/functions/major.js'(e, t) {
        var a = H();
        t.exports = (e, t) => new a(e, t).major;
      },
    }),
    te = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/functions/minor.js'(e, t) {
        var a = H();
        t.exports = (e, t) => new a(e, t).minor;
      },
    }),
    ae = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/functions/patch.js'(e, t) {
        var a = H();
        t.exports = (e, t) => new a(e, t).patch;
      },
    }),
    re = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/functions/prerelease.js'(e, t) {
        var a = q();
        t.exports = (e, t) => {
          e = a(e, t);
          return e && e.prerelease.length ? e.prerelease : null;
        };
      },
    }),
    G = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/functions/compare.js'(e, t) {
        var r = H();
        t.exports = (e, t, a) => new r(e, a).compare(new r(t, a));
      },
    }),
    ne = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/functions/rcompare.js'(e, t) {
        var r = G();
        t.exports = (e, t, a) => r(t, e, a);
      },
    }),
    oe = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/functions/compare-loose.js'(e, t) {
        var a = G();
        t.exports = (e, t) => a(e, t, !0);
      },
    }),
    ie = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/functions/compare-build.js'(e, t) {
        var r = H();
        t.exports = (e, t, a) => {
          (e = new r(e, a)), (t = new r(t, a));
          return e.compare(t) || e.compareBuild(t);
        };
      },
    }),
    se = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/functions/sort.js'(e, t) {
        var r = ie();
        t.exports = (e, a) => e.sort((e, t) => r(e, t, a));
      },
    }),
    le = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/functions/rsort.js'(e, t) {
        var r = ie();
        t.exports = (e, a) => e.sort((e, t) => r(t, e, a));
      },
    }),
    ce = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/functions/gt.js'(e, t) {
        var r = G();
        t.exports = (e, t, a) => 0 < r(e, t, a);
      },
    }),
    ue = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/functions/lt.js'(e, t) {
        var r = G();
        t.exports = (e, t, a) => r(e, t, a) < 0;
      },
    }),
    de = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/functions/eq.js'(e, t) {
        var r = G();
        t.exports = (e, t, a) => 0 === r(e, t, a);
      },
    }),
    pe = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/functions/neq.js'(e, t) {
        var r = G();
        t.exports = (e, t, a) => 0 !== r(e, t, a);
      },
    }),
    he = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/functions/gte.js'(e, t) {
        var r = G();
        t.exports = (e, t, a) => 0 <= r(e, t, a);
      },
    }),
    me = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/functions/lte.js'(e, t) {
        var r = G();
        t.exports = (e, t, a) => r(e, t, a) <= 0;
      },
    }),
    fe = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/functions/cmp.js'(e, t) {
        var n = de(),
          o = pe(),
          i = ce(),
          s = he(),
          l = ue(),
          c = me();
        t.exports = (e, t, a, r) => {
          switch (t) {
            case '===':
              return (e = 'object' == typeof e ? e.version : e) === (a = 'object' == typeof a ? a.version : a);
            case '!==':
              return (e = 'object' == typeof e ? e.version : e) !== (a = 'object' == typeof a ? a.version : a);
            case '':
            case '=':
            case '==':
              return n(e, a, r);
            case '!=':
              return o(e, a, r);
            case '>':
              return i(e, a, r);
            case '>=':
              return s(e, a, r);
            case '<':
              return l(e, a, r);
            case '<=':
              return c(e, a, r);
            default:
              throw new TypeError('Invalid operator: ' + t);
          }
        };
      },
    }),
    ge = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/functions/coerce.js'(e, t) {
        var u = H(),
          d = q(),
          { safeRe: p, t: h } = V();
        t.exports = (e, t) => {
          if (e instanceof u) return e;
          if ('string' != typeof (e = 'number' == typeof e ? String(e) : e)) return null;
          let a = null;
          if ((t = t || {}).rtl) {
            for (
              var r, n = t.includePrerelease ? p[h.COERCERTLFULL] : p[h.COERCERTL];
              (r = n.exec(e)) && (!a || a.index + a[0].length !== e.length);

            )
              (a && r.index + r[0].length === a.index + a[0].length) || (a = r),
                (n.lastIndex = r.index + r[1].length + r[2].length);
            n.lastIndex = -1;
          } else a = e.match(t.includePrerelease ? p[h.COERCEFULL] : p[h.COERCE]);
          var o, i, s, l, c;
          return null === a
            ? null
            : ((o = a[2]),
              (i = a[3] || '0'),
              (s = a[4] || '0'),
              (l = t.includePrerelease && a[5] ? '-' + a[5] : ''),
              (c = t.includePrerelease && a[6] ? '+' + a[6] : ''),
              d(o + `.${i}.` + s + l + c, t));
        };
      },
    }),
    F = e({
      'node_modules/.pnpm/yallist@4.0.0/node_modules/yallist/iterator.js'(e, t) {
        'use strict';
        t.exports = function (e) {
          e.prototype[Symbol.iterator] = function* () {
            for (let e = this.head; e; e = e.next) yield e.value;
          };
        };
      },
    }),
    ve = e({
      'node_modules/.pnpm/yallist@4.0.0/node_modules/yallist/yallist.js'(e, t) {
        'use strict';
        function o(e) {
          var t = this;
          if (
            (((t = t instanceof o ? t : new o()).tail = null),
            (t.head = null),
            (t.length = 0),
            e && 'function' == typeof e.forEach)
          )
            e.forEach(function (e) {
              t.push(e);
            });
          else if (0 < arguments.length) for (var a = 0, r = arguments.length; a < r; a++) t.push(arguments[a]);
          return t;
        }
        function i(e, t, a, r) {
          if (!(this instanceof i)) return new i(e, t, a, r);
          (this.list = r),
            (this.value = e),
            t ? ((t.next = this).prev = t) : (this.prev = null),
            a ? ((a.prev = this).next = a) : (this.next = null);
        }
        ((t.exports = o).Node = i),
          ((o.create = o).prototype.removeNode = function (e) {
            if (e.list !== this) throw new Error('removing node which does not belong to this list');
            var t = e.next,
              a = e.prev;
            return (
              t && (t.prev = a),
              a && (a.next = t),
              e === this.head && (this.head = t),
              e === this.tail && (this.tail = a),
              e.list.length--,
              (e.next = null),
              (e.prev = null),
              (e.list = null),
              t
            );
          }),
          (o.prototype.unshiftNode = function (e) {
            var t;
            e !== this.head &&
              (e.list && e.list.removeNode(e),
              (t = this.head),
              (e.list = this),
              (e.next = t) && (t.prev = e),
              (this.head = e),
              this.tail || (this.tail = e),
              this.length++);
          }),
          (o.prototype.pushNode = function (e) {
            var t;
            e !== this.tail &&
              (e.list && e.list.removeNode(e),
              (t = this.tail),
              (e.list = this),
              (e.prev = t) && (t.next = e),
              (this.tail = e),
              this.head || (this.head = e),
              this.length++);
          }),
          (o.prototype.push = function () {
            for (var e = 0, t = arguments.length; e < t; e++) {
              r = a = void 0;
              var a = this,
                r = arguments[e];
              (a.tail = new i(r, a.tail, null, a)), a.head || (a.head = a.tail), a.length++;
            }
            return this.length;
          }),
          (o.prototype.unshift = function () {
            for (var e = 0, t = arguments.length; e < t; e++) {
              r = a = void 0;
              var a = this,
                r = arguments[e];
              (a.head = new i(r, null, a.head, a)), a.tail || (a.tail = a.head), a.length++;
            }
            return this.length;
          }),
          (o.prototype.pop = function () {
            var e;
            if (this.tail)
              return (
                (e = this.tail.value),
                (this.tail = this.tail.prev),
                this.tail ? (this.tail.next = null) : (this.head = null),
                this.length--,
                e
              );
          }),
          (o.prototype.shift = function () {
            var e;
            if (this.head)
              return (
                (e = this.head.value),
                (this.head = this.head.next),
                this.head ? (this.head.prev = null) : (this.tail = null),
                this.length--,
                e
              );
          }),
          (o.prototype.forEach = function (e, t) {
            t = t || this;
            for (var a = this.head, r = 0; null !== a; r++) e.call(t, a.value, r, this), (a = a.next);
          }),
          (o.prototype.forEachReverse = function (e, t) {
            t = t || this;
            for (var a = this.tail, r = this.length - 1; null !== a; r--) e.call(t, a.value, r, this), (a = a.prev);
          }),
          (o.prototype.get = function (e) {
            for (var t = 0, a = this.head; null !== a && t < e; t++) a = a.next;
            if (t === e && null !== a) return a.value;
          }),
          (o.prototype.getReverse = function (e) {
            for (var t = 0, a = this.tail; null !== a && t < e; t++) a = a.prev;
            if (t === e && null !== a) return a.value;
          }),
          (o.prototype.map = function (e, t) {
            t = t || this;
            for (var a = new o(), r = this.head; null !== r; ) a.push(e.call(t, r.value, this)), (r = r.next);
            return a;
          }),
          (o.prototype.mapReverse = function (e, t) {
            t = t || this;
            for (var a = new o(), r = this.tail; null !== r; ) a.push(e.call(t, r.value, this)), (r = r.prev);
            return a;
          }),
          (o.prototype.reduce = function (e, t) {
            var a,
              r = this.head;
            if (1 < arguments.length) a = t;
            else {
              if (!this.head) throw new TypeError('Reduce of empty list with no initial value');
              (r = this.head.next), (a = this.head.value);
            }
            for (var n = 0; null !== r; n++) (a = e(a, r.value, n)), (r = r.next);
            return a;
          }),
          (o.prototype.reduceReverse = function (e, t) {
            var a,
              r = this.tail;
            if (1 < arguments.length) a = t;
            else {
              if (!this.tail) throw new TypeError('Reduce of empty list with no initial value');
              (r = this.tail.prev), (a = this.tail.value);
            }
            for (var n = this.length - 1; null !== r; n--) (a = e(a, r.value, n)), (r = r.prev);
            return a;
          }),
          (o.prototype.toArray = function () {
            for (var e = new Array(this.length), t = 0, a = this.head; null !== a; t++) (e[t] = a.value), (a = a.next);
            return e;
          }),
          (o.prototype.toArrayReverse = function () {
            for (var e = new Array(this.length), t = 0, a = this.tail; null !== a; t++) (e[t] = a.value), (a = a.prev);
            return e;
          }),
          (o.prototype.slice = function (e, t) {
            (t = t || this.length) < 0 && (t += this.length), (e = e || 0) < 0 && (e += this.length);
            var a = new o();
            if (!(t < e || t < 0)) {
              e < 0 && (e = 0), t > this.length && (t = this.length);
              for (var r = 0, n = this.head; null !== n && r < e; r++) n = n.next;
              for (; null !== n && r < t; r++, n = n.next) a.push(n.value);
            }
            return a;
          }),
          (o.prototype.sliceReverse = function (e, t) {
            (t = t || this.length) < 0 && (t += this.length), (e = e || 0) < 0 && (e += this.length);
            var a = new o();
            if (!(t < e || t < 0)) {
              e < 0 && (e = 0), t > this.length && (t = this.length);
              for (var r = this.length, n = this.tail; null !== n && t < r; r--) n = n.prev;
              for (; null !== n && e < r; r--, n = n.prev) a.push(n.value);
            }
            return a;
          }),
          (o.prototype.splice = function (e, t, ...a) {
            (e = e > this.length ? this.length - 1 : e) < 0 && (e = this.length + e);
            for (var r = 0, n = this.head; null !== n && r < e; r++) n = n.next;
            for (var o = [], r = 0; n && r < t; r++) o.push(n.value), (n = this.removeNode(n));
            (n = null === n ? this.tail : n) !== this.head && n !== this.tail && (n = n.prev);
            for (r = 0; r < a.length; r++)
              n = (function (e, t, a) {
                a = t === e.head ? new i(a, null, t, e) : new i(a, t, t.next, e);
                null === a.next && (e.tail = a);
                null === a.prev && (e.head = a);
                return e.length++, a;
              })(this, n, a[r]);
            return o;
          }),
          (o.prototype.reverse = function () {
            for (var e = this.head, t = this.tail, a = e; null !== a; a = a.prev) {
              var r = a.prev;
              (a.prev = a.next), (a.next = r);
            }
            return (this.head = t), (this.tail = e), this;
          });
        try {
          F()(o);
        } catch (e) {}
      },
    }),
    be = e({
      'node_modules/.pnpm/lru-cache@6.0.0/node_modules/lru-cache/index.js'(e, t) {
        'use strict';
        var a = ve(),
          i = Symbol('max'),
          s = Symbol('length'),
          l = Symbol('lengthCalculator'),
          o = Symbol('allowStale'),
          c = Symbol('maxAge'),
          u = Symbol('dispose'),
          d = Symbol('noDisposeOnSet'),
          p = Symbol('lruList'),
          h = Symbol('cache'),
          n = Symbol('updateAgeOnGet'),
          r = () => 1,
          m = (e, t, a) => {
            t = e[h].get(t);
            if (t) {
              var r = t.value;
              if (f(e, r)) {
                if ((v(e, t), !e[o])) return;
              } else a && (e[n] && (t.value.now = Date.now()), e[p].unshiftNode(t));
              return r.value;
            }
          },
          f = (e, t) => {
            var a;
            return (
              !(!t || (!t.maxAge && !e[c])) && ((a = Date.now() - t.now), t.maxAge ? a > t.maxAge : e[c] && a > e[c])
            );
          },
          g = (t) => {
            if (t[s] > t[i])
              for (let e = t[p].tail; t[s] > t[i] && null !== e; ) {
                var a = e.prev;
                v(t, e), (e = a);
              }
          },
          v = (e, t) => {
            var a;
            t &&
              ((a = t.value), e[u] && e[u](a.key, a.value), (e[s] -= a.length), e[h].delete(a.key), e[p].removeNode(t));
          },
          b = class {
            constructor(e, t, a, r, n) {
              (this.key = e), (this.value = t), (this.length = a), (this.now = r), (this.maxAge = n || 0);
            }
          },
          y = (e, t, a, r) => {
            let n = a.value;
            f(e, n) && (v(e, a), e[o] || (n = void 0)), n && t.call(r, n.value, n.key, e);
          };
        t.exports = class {
          constructor(e) {
            if ((e = (e = 'number' == typeof e ? { max: e } : e) || {}).max && ('number' != typeof e.max || e.max < 0))
              throw new TypeError('max must be a non-negative number');
            this[i] = e.max || 1 / 0;
            var t = e.length || r;
            if (
              ((this[l] = 'function' != typeof t ? r : t),
              (this[o] = e.stale || !1),
              e.maxAge && 'number' != typeof e.maxAge)
            )
              throw new TypeError('maxAge must be a number');
            (this[c] = e.maxAge || 0),
              (this[u] = e.dispose),
              (this[d] = e.noDisposeOnSet || !1),
              (this[n] = e.updateAgeOnGet || !1),
              this.reset();
          }
          set max(e) {
            if ('number' != typeof e || e < 0) throw new TypeError('max must be a non-negative number');
            (this[i] = e || 1 / 0), g(this);
          }
          get max() {
            return this[i];
          }
          set allowStale(e) {
            this[o] = !!e;
          }
          get allowStale() {
            return this[o];
          }
          set maxAge(e) {
            if ('number' != typeof e) throw new TypeError('maxAge must be a non-negative number');
            (this[c] = e), g(this);
          }
          get maxAge() {
            return this[c];
          }
          set lengthCalculator(e) {
            (e = 'function' != typeof e ? r : e) !== this[l] &&
              ((this[l] = e),
              (this[s] = 0),
              this[p].forEach((e) => {
                (e.length = this[l](e.value, e.key)), (this[s] += e.length);
              })),
              g(this);
          }
          get lengthCalculator() {
            return this[l];
          }
          get length() {
            return this[s];
          }
          get itemCount() {
            return this[p].length;
          }
          rforEach(t, a) {
            a = a || this;
            for (let e = this[p].tail; null !== e; ) {
              var r = e.prev;
              y(this, t, e, a), (e = r);
            }
          }
          forEach(t, a) {
            a = a || this;
            for (let e = this[p].head; null !== e; ) {
              var r = e.next;
              y(this, t, e, a), (e = r);
            }
          }
          keys() {
            return this[p].toArray().map((e) => e.key);
          }
          values() {
            return this[p].toArray().map((e) => e.value);
          }
          reset() {
            this[u] && this[p] && this[p].length && this[p].forEach((e) => this[u](e.key, e.value)),
              (this[h] = new Map()),
              (this[p] = new a()),
              (this[s] = 0);
          }
          dump() {
            return this[p]
              .map((e) => !f(this, e) && { k: e.key, v: e.value, e: e.now + (e.maxAge || 0) })
              .toArray()
              .filter((e) => e);
          }
          dumpLru() {
            return this[p];
          }
          set(e, t, a) {
            if ((a = a || this[c]) && 'number' != typeof a) throw new TypeError('maxAge must be a number');
            var r,
              n = a ? Date.now() : 0,
              o = this[l](t, e);
            return this[h].has(e)
              ? o > this[i]
                ? (v(this, this[h].get(e)), !1)
                : ((r = this[h].get(e).value),
                  this[u] && !this[d] && this[u](e, r.value),
                  (r.now = n),
                  (r.maxAge = a),
                  (r.value = t),
                  (this[s] += o - r.length),
                  (r.length = o),
                  this.get(e),
                  g(this),
                  !0)
              : (r = new b(e, t, o, n, a)).length > this[i]
                ? (this[u] && this[u](e, t), !1)
                : ((this[s] += r.length), this[p].unshift(r), this[h].set(e, this[p].head), g(this), !0);
          }
          has(e) {
            return !!this[h].has(e) && ((e = this[h].get(e).value), !f(this, e));
          }
          get(e) {
            return m(this, e, !0);
          }
          peek(e) {
            return m(this, e, !1);
          }
          pop() {
            var e = this[p].tail;
            return e ? (v(this, e), e.value) : null;
          }
          del(e) {
            v(this, this[h].get(e));
          }
          load(t) {
            this.reset();
            var a = Date.now();
            for (let e = t.length - 1; 0 <= e; e--) {
              var r = t[e],
                n = r.e || 0;
              0 === n ? this.set(r.k, r.v) : 0 < (n = n - a) && this.set(r.k, r.v, n);
            }
          }
          prune() {
            this[h].forEach((e, t) => m(this, t, !1));
          }
        };
      },
    }),
    K = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/classes/range.js'(e, t) {
        var r = class {
          constructor(e, t) {
            if (((t = n(t)), e instanceof r))
              return e.loose === !!t.loose && e.includePrerelease === !!t.includePrerelease ? e : new r(e.raw, t);
            if (e instanceof l) return (this.raw = e.value), (this.set = [[e]]), this.format(), this;
            if (
              ((this.options = t),
              (this.loose = !!t.loose),
              (this.includePrerelease = !!t.includePrerelease),
              (this.raw = e.trim().split(/\s+/).join(' ')),
              (this.set = this.raw
                .split('||')
                .map((e) => this.parseRange(e.trim()))
                .filter((e) => e.length)),
              !this.set.length)
            )
              throw new TypeError('Invalid SemVer Range: ' + this.raw);
            if (1 < this.set.length) {
              t = this.set[0];
              if (((this.set = this.set.filter((e) => !v(e[0]))), 0 === this.set.length)) this.set = [t];
              else if (1 < this.set.length)
                for (const a of this.set)
                  if (1 === a.length && o(a[0])) {
                    this.set = [a];
                    break;
                  }
            }
            this.format();
          }
          format() {
            return (
              (this.range = this.set
                .map((e) => e.join(' ').trim())
                .join('||')
                .trim()),
              this.range
            );
          }
          toString() {
            return this.range;
          }
          parseRange(e) {
            var t = ((this.options.includePrerelease && f) | (this.options.loose && g)) + ':' + e,
              a = s.get(t);
            if (a) return a;
            var a = this.options.loose,
              r = a ? p[h.HYPHENRANGELOOSE] : p[h.HYPHENRANGE];
            (e = e.replace(r, L(this.options.includePrerelease))),
              d('hyphen replace', e),
              (e = e.replace(p[h.COMPARATORTRIM], c)),
              d('comparator trim', e),
              (e = e.replace(p[h.TILDETRIM], u)),
              d('tilde trim', e),
              (e = e.replace(p[h.CARETTRIM], m)),
              d('caret trim', e);
            let n = e
              .split(' ')
              .map((e) => b(e, this.options))
              .join(' ')
              .split(/\s+/)
              .map((e) => I(e, this.options));
            a && (n = n.filter((e) => (d('loose invalid filter', e, this.options), !!e.match(p[h.COMPARATORLOOSE])))),
              d('range list', n);
            var o = new Map();
            for (const i of n.map((e) => new l(e, this.options))) {
              if (v(i)) return [i];
              o.set(i.value, i);
            }
            1 < o.size && o.has('') && o.delete('');
            r = [...o.values()];
            return s.set(t, r), r;
          }
          intersects(e, a) {
            if (e instanceof r)
              return this.set.some(
                (t) => i(t, a) && e.set.some((e) => i(e, a) && t.every((t) => e.every((e) => t.intersects(e, a)))),
              );
            throw new TypeError('a Range is required');
          }
          test(t) {
            if (t) {
              if ('string' == typeof t)
                try {
                  t = new a(t, this.options);
                } catch (e) {
                  return !1;
                }
              for (let e = 0; e < this.set.length; e++) if (O(this.set[e], t, this.options)) return !0;
            }
            return !1;
          }
        };
        t.exports = r;
        var s = new (be())({ max: 1e3 }),
          n = B(),
          l = ye(),
          d = U(),
          a = H(),
          { safeRe: p, t: h, comparatorTrimReplace: c, tildeTrimReplace: u, caretTrimReplace: m } = V(),
          { FLAG_INCLUDE_PRERELEASE: f, FLAG_LOOSE: g } = J(),
          v = (e) => '<0.0.0-0' === e.value,
          o = (e) => '' === e.value,
          i = (e, t) => {
            let a = !0;
            var r = e.slice();
            let n = r.pop();
            for (; a && r.length; ) (a = r.every((e) => n.intersects(e, t))), (n = r.pop());
            return a;
          },
          b = (e, t) => (
            d('comp', e, t),
            (e = w(e, t)),
            d('caret', e),
            (e = S(e, t)),
            d('tildes', e),
            (e = C(e, t)),
            d('xrange', e),
            (e = x(e, t)),
            d('stars', e),
            e
          ),
          y = (e) => !e || 'x' === e.toLowerCase() || '*' === e,
          S = (e, t) =>
            e
              .trim()
              .split(/\s+/)
              .map((e) => k(e, t))
              .join(' '),
          k = (i, e) => {
            e = e.loose ? p[h.TILDELOOSE] : p[h.TILDE];
            return i.replace(e, (e, t, a, r, n) => {
              d('tilde', i, e, t, a, r, n);
              let o;
              return (
                (o = y(t)
                  ? ''
                  : y(a)
                    ? `>=${t}.0.0 <${+t + 1}.0.0-0`
                    : y(r)
                      ? `>=${t}.${a}.0 <${t}.${+a + 1}.0-0`
                      : n
                        ? (d('replaceTilde pr', n), `>=${t}.${a}.${r}-${n} <${t}.${+a + 1}.0-0`)
                        : `>=${t}.${a}.${r} <${t}.${+a + 1}.0-0`),
                d('tilde return', o),
                o
              );
            });
          },
          w = (e, t) =>
            e
              .trim()
              .split(/\s+/)
              .map((e) => E(e, t))
              .join(' '),
          E = (i, e) => {
            d('caret', i, e);
            var t = e.loose ? p[h.CARETLOOSE] : p[h.CARET];
            const s = e.includePrerelease ? '-0' : '';
            return i.replace(t, (e, t, a, r, n) => {
              d('caret', i, e, t, a, r, n);
              let o;
              return (
                (o = y(t)
                  ? ''
                  : y(a)
                    ? `>=${t}.0.0${s} <${+t + 1}.0.0-0`
                    : y(r)
                      ? '0' === t
                        ? `>=${t}.${a}.0${s} <${t}.${+a + 1}.0-0`
                        : `>=${t}.${a}.0${s} <${+t + 1}.0.0-0`
                      : n
                        ? (d('replaceCaret pr', n),
                          '0' === t
                            ? '0' === a
                              ? `>=${t}.${a}.${r}-${n} <${t}.${a}.${+r + 1}-0`
                              : `>=${t}.${a}.${r}-${n} <${t}.${+a + 1}.0-0`
                            : `>=${t}.${a}.${r}-${n} <${+t + 1}.0.0-0`)
                        : (d('no pr'),
                          '0' === t
                            ? '0' === a
                              ? `>=${t}.${a}.${r}${s} <${t}.${a}.${+r + 1}-0`
                              : `>=${t}.${a}.${r}${s} <${t}.${+a + 1}.0-0`
                            : `>=${t}.${a}.${r} <${+t + 1}.0.0-0`)),
                d('caret return', o),
                o
              );
            });
          },
          C = (e, t) => (
            d('replaceXRanges', e, t),
            e
              .split(/\s+/)
              .map((e) => N(e, t))
              .join(' ')
          ),
          N = (c, u) => {
            c = c.trim();
            var e = u.loose ? p[h.XRANGELOOSE] : p[h.XRANGE];
            return c.replace(e, (e, t, a, r, n, o) => {
              d('xRange', c, e, t, a, r, n, o);
              var i = y(a),
                s = i || y(r),
                l = s || y(n);
              return (
                '=' === t && l && (t = ''),
                (o = u.includePrerelease ? '-0' : ''),
                i
                  ? (e = '>' === t || '<' === t ? '<0.0.0-0' : '*')
                  : t && l
                    ? (s && (r = 0),
                      (n = 0),
                      '>' === t
                        ? ((t = '>='), (n = s ? ((a = +a + 1), (r = 0)) : ((r = +r + 1), 0)))
                        : '<=' === t && ((t = '<'), s ? (a = +a + 1) : (r = +r + 1)),
                      (e = t + a + `.${r}.` + n + (o = '<' === t ? '-0' : o)))
                    : s
                      ? (e = `>=${a}.0.0${o} <${+a + 1}.0.0-0`)
                      : l && (e = `>=${a}.${r}.0${o} <${a}.${+r + 1}.0-0`),
                d('xRange return', e),
                e
              );
            });
          },
          x = (e, t) => (d('replaceStars', e, t), e.trim().replace(p[h.STAR], '')),
          I = (e, t) => (d('replaceGTE0', e, t), e.trim().replace(p[t.includePrerelease ? h.GTE0PRE : h.GTE0], '')),
          L = (h) => (e, t, a, r, n, o, i, s, l, c, u, d, p) =>
            (
              (t = y(a)
                ? ''
                : y(r)
                  ? `>=${a}.0.0` + (h ? '-0' : '')
                  : y(n)
                    ? `>=${a}.${r}.0` + (h ? '-0' : '')
                    : o
                      ? '>=' + t
                      : '>=' + t + (h ? '-0' : '')) +
              ' ' +
              (s = y(l)
                ? ''
                : y(c)
                  ? `<${+l + 1}.0.0-0`
                  : y(u)
                    ? `<${l}.${+c + 1}.0-0`
                    : d
                      ? `<=${l}.${c}.${u}-` + d
                      : h
                        ? `<${l}.${c}.${+u + 1}-0`
                        : '<=' + s)
            ).trim(),
          O = (t, a, e) => {
            for (let e = 0; e < t.length; e++) if (!t[e].test(a)) return !1;
            if (!a.prerelease.length || e.includePrerelease) return !0;
            for (let e = 0; e < t.length; e++)
              if ((d(t[e].semver), t[e].semver !== l.ANY && 0 < t[e].semver.prerelease.length)) {
                var r = t[e].semver;
                if (r.major === a.major && r.minor === a.minor && r.patch === a.patch) return !0;
              }
            return !1;
          };
      },
    }),
    ye = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/classes/comparator.js'(e, t) {
        var a = Symbol('SemVer ANY'),
          r = class {
            static get ANY() {
              return a;
            }
            constructor(e, t) {
              if (((t = n(t)), e instanceof r)) {
                if (e.loose === !!t.loose) return e;
                e = e.value;
              }
              (e = e.trim().split(/\s+/).join(' ')),
                l('comparator', e, t),
                (this.options = t),
                (this.loose = !!t.loose),
                this.parse(e),
                this.semver === a ? (this.value = '') : (this.value = this.operator + this.semver.version),
                l('comp', this);
            }
            parse(e) {
              var t = this.options.loose ? o[i.COMPARATORLOOSE] : o[i.COMPARATOR],
                t = e.match(t);
              if (!t) throw new TypeError('Invalid comparator: ' + e);
              (this.operator = void 0 !== t[1] ? t[1] : ''),
                '=' === this.operator && (this.operator = ''),
                t[2] ? (this.semver = new c(t[2], this.options.loose)) : (this.semver = a);
            }
            toString() {
              return this.value;
            }
            test(e) {
              if ((l('Comparator.test', e, this.options.loose), this.semver === a || e === a)) return !0;
              if ('string' == typeof e)
                try {
                  e = new c(e, this.options);
                } catch (e) {
                  return !1;
                }
              return s(e, this.operator, this.semver, this.options);
            }
            intersects(e, t) {
              if (e instanceof r)
                return '' === this.operator
                  ? '' === this.value || new u(e.value, t).test(this.value)
                  : '' === e.operator
                    ? '' === e.value || new u(this.value, t).test(e.semver)
                    : (!(t = n(t)).includePrerelease || ('<0.0.0-0' !== this.value && '<0.0.0-0' !== e.value)) &&
                      !(
                        (!t.includePrerelease && (this.value.startsWith('<0.0.0') || e.value.startsWith('<0.0.0'))) ||
                        ((!this.operator.startsWith('>') || !e.operator.startsWith('>')) &&
                          !(
                            (this.operator.startsWith('<') && e.operator.startsWith('<')) ||
                            (this.semver.version === e.semver.version &&
                              this.operator.includes('=') &&
                              e.operator.includes('=')) ||
                            (s(this.semver, '<', e.semver, t) &&
                              this.operator.startsWith('>') &&
                              e.operator.startsWith('<')) ||
                            (s(this.semver, '>', e.semver, t) &&
                              this.operator.startsWith('<') &&
                              e.operator.startsWith('>'))
                          ))
                      );
              throw new TypeError('a Comparator is required');
            }
          },
          n = ((t.exports = r), B()),
          { safeRe: o, t: i } = V(),
          s = fe(),
          l = U(),
          c = H(),
          u = K();
      },
    }),
    Se = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/functions/satisfies.js'(e, t) {
        var r = K();
        t.exports = (e, t, a) => {
          try {
            t = new r(t, a);
          } catch (e) {
            return !1;
          }
          return t.test(e);
        };
      },
    }),
    ke = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/ranges/to-comparators.js'(e, t) {
        var a = K();
        t.exports = (e, t) =>
          new a(e, t).set.map((e) =>
            e
              .map((e) => e.value)
              .join(' ')
              .trim()
              .split(' '),
          );
      },
    }),
    we = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/ranges/max-satisfying.js'(e, t) {
        var i = H(),
          s = K();
        t.exports = (e, t, a) => {
          let r = null,
            n = null,
            o = null;
          try {
            o = new s(t, a);
          } catch (e) {
            return null;
          }
          return (
            e.forEach((e) => {
              !o.test(e) || (r && -1 !== n.compare(e)) || ((r = e), (n = new i(r, a)));
            }),
            r
          );
        };
      },
    }),
    Ee = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/ranges/min-satisfying.js'(e, t) {
        var i = H(),
          s = K();
        t.exports = (e, t, a) => {
          let r = null,
            n = null,
            o = null;
          try {
            o = new s(t, a);
          } catch (e) {
            return null;
          }
          return (
            e.forEach((e) => {
              !o.test(e) || (r && 1 !== n.compare(e)) || ((r = e), (n = new i(r, a)));
            }),
            r
          );
        };
      },
    }),
    Ce = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/ranges/min-version.js'(e, t) {
        var o = H(),
          a = K(),
          i = ce();
        t.exports = (t, e) => {
          t = new a(t, e);
          let r = new o('0.0.0');
          if (t.test(r)) return r;
          if (((r = new o('0.0.0-0')), t.test(r))) return r;
          r = null;
          for (let e = 0; e < t.set.length; ++e) {
            var n = t.set[e];
            let a = null;
            n.forEach((e) => {
              var t = new o(e.semver.version);
              switch (e.operator) {
                case '>':
                  0 === t.prerelease.length ? t.patch++ : t.prerelease.push(0), (t.raw = t.format());
                case '':
                case '>=':
                  (a && !i(t, a)) || (a = t);
                  break;
                case '<':
                case '<=':
                  break;
                default:
                  throw new Error('Unexpected operation: ' + e.operator);
              }
            }),
              !a || (r && !i(r, a)) || (r = a);
          }
          return r && t.test(r) ? r : null;
        };
      },
    }),
    Ne = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/ranges/valid.js'(e, t) {
        var a = K();
        t.exports = (e, t) => {
          try {
            return new a(e, t).range || '*';
          } catch (e) {
            return null;
          }
        };
      },
    }),
    xe = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/ranges/outside.js'(e, t) {
        var a = H(),
          p = ye(),
          h = p['ANY'],
          m = K(),
          f = Se(),
          g = ce(),
          v = ue(),
          b = me(),
          y = he();
        t.exports = (r, n, e, o) => {
          (r = new a(r, o)), (n = new m(n, o));
          let i, s, l, c, u;
          switch (e) {
            case '>':
              (i = g), (s = b), (l = v), (c = '>'), (u = '>=');
              break;
            case '<':
              (i = v), (s = y), (l = g), (c = '<'), (u = '<=');
              break;
            default:
              throw new TypeError('Must provide a hilo val of "<" or ">"');
          }
          if (f(r, n, o)) return !1;
          for (let e = 0; e < n.set.length; ++e) {
            var d = n.set[e];
            let t = null,
              a = null;
            if (
              (d.forEach((e) => {
                e.semver === h && (e = new p('>=0.0.0')),
                  (t = t || e),
                  (a = a || e),
                  i(e.semver, t.semver, o) ? (t = e) : l(e.semver, a.semver, o) && (a = e);
              }),
              t.operator === c || t.operator === u)
            )
              return !1;
            if ((!a.operator || a.operator === c) && s(r, a.semver)) return !1;
            if (a.operator === u && l(r, a.semver)) return !1;
          }
          return !0;
        };
      },
    }),
    Ie = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/ranges/gtr.js'(e, t) {
        var r = xe();
        t.exports = (e, t, a) => r(e, t, '>', a);
      },
    }),
    Le = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/ranges/ltr.js'(e, t) {
        var r = xe();
        t.exports = (e, t, a) => r(e, t, '<', a);
      },
    }),
    Oe = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/ranges/intersects.js'(e, t) {
        var r = K();
        t.exports = (e, t, a) => ((e = new r(e, a)), (t = new r(t, a)), e.intersects(t, a));
      },
    }),
    Te = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/ranges/simplify.js'(e, t) {
        var h = Se(),
          m = G();
        t.exports = (e, t, a) => {
          var r = [];
          let n = null,
            o = null;
          var i = e.sort((e, t) => m(e, t, a));
          for (const p of i) {
            var s = h(p, t, a);
            n = s ? ((o = p), n || p) : (o && r.push([n, o]), (o = null));
          }
          n && r.push([n, null]);
          var l,
            c,
            u = [];
          for ([l, c] of r)
            l === c
              ? u.push(l)
              : c || l !== i[0]
                ? c
                  ? l === i[0]
                    ? u.push('<=' + c)
                    : u.push(l + ' - ' + c)
                  : u.push('>=' + l)
                : u.push('*');
          var e = u.join(' || '),
            d = 'string' == typeof t.raw ? t.raw : String(t);
          return e.length < d.length ? e : t;
        };
      },
    }),
    Ae = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/ranges/subset.js'(e, t) {
        var s = K(),
          a = ye(),
          v = a['ANY'],
          b = Se(),
          y = G(),
          S = [new a('>=0.0.0-0')],
          k = [new a('>=0.0.0')],
          w = (e, t, a) => {
            return !e ||
              (!(0 < (a = y(e.semver, t.semver, a))) && (a < 0 || ('>' === t.operator && '>=' === e.operator)))
              ? t
              : e;
          },
          E = (e, t, a) => {
            return !e ||
              (!((a = y(e.semver, t.semver, a)) < 0) && (0 < a || ('<' === t.operator && '<=' === e.operator)))
              ? t
              : e;
          };
        t.exports = (t, a, r = {}) => {
          if (t !== a) {
            (t = new s(t, r)), (a = new s(a, r));
            let e = !1;
            e: for (const o of t.set) {
              for (const i of a.set) {
                var n = ((s, l, c) => {
                  if (s !== l) {
                    if (1 === s.length && s[0].semver === v) {
                      if (1 === l.length && l[0].semver === v) return !0;
                      s = c.includePrerelease ? S : k;
                    }
                    if (1 === l.length && l[0].semver === v) {
                      if (c.includePrerelease) return !0;
                      l = k;
                    }
                    var u = new Set(),
                      d,
                      p;
                    let e, t;
                    for (const h of s)
                      '>' === h.operator || '>=' === h.operator
                        ? (e = w(e, h, c))
                        : '<' === h.operator || '<=' === h.operator
                          ? (t = E(t, h, c))
                          : u.add(h.semver);
                    if (1 < u.size) return null;
                    let a;
                    if (e && t) {
                      if (0 < (a = y(e.semver, t.semver, c))) return null;
                      if (0 === a && ('>=' !== e.operator || '<=' !== t.operator)) return null;
                    }
                    for (const m of u) {
                      if (e && !b(m, String(e), c)) return null;
                      if (t && !b(m, String(t), c)) return null;
                      for (const f of l) if (!b(m, String(f), c)) return !1;
                      return !0;
                    }
                    let r,
                      n,
                      o = !(!t || c.includePrerelease || !t.semver.prerelease.length) && t.semver,
                      i = !(!e || c.includePrerelease || !e.semver.prerelease.length) && e.semver;
                    o && 1 === o.prerelease.length && '<' === t.operator && 0 === o.prerelease[0] && (o = !1);
                    for (const g of l) {
                      if (
                        ((n = n || '>' === g.operator || '>=' === g.operator),
                        (r = r || '<' === g.operator || '<=' === g.operator),
                        e)
                      )
                        if (
                          (i &&
                            g.semver.prerelease &&
                            g.semver.prerelease.length &&
                            g.semver.major === i.major &&
                            g.semver.minor === i.minor &&
                            g.semver.patch === i.patch &&
                            (i = !1),
                          '>' === g.operator || '>=' === g.operator)
                        ) {
                          if ((d = w(e, g, c)) === g && d !== e) return !1;
                        } else if ('>=' === e.operator && !b(e.semver, String(g), c)) return !1;
                      if (t)
                        if (
                          (o &&
                            g.semver.prerelease &&
                            g.semver.prerelease.length &&
                            g.semver.major === o.major &&
                            g.semver.minor === o.minor &&
                            g.semver.patch === o.patch &&
                            (o = !1),
                          '<' === g.operator || '<=' === g.operator)
                        ) {
                          if ((p = E(t, g, c)) === g && p !== t) return !1;
                        } else if ('<=' === t.operator && !b(t.semver, String(g), c)) return !1;
                      if (!g.operator && (t || e) && 0 !== a) return !1;
                    }
                    if (e && r && !t && 0 !== a) return !1;
                    if (t && n && !e && 0 !== a) return !1;
                    if (i || o) return !1;
                  }
                  return true;
                })(o, i, r);
                if (((e = e || null !== n), n)) continue e;
              }
              if (e) return !1;
            }
          }
          return !0;
        };
      },
    }),
    a = e({
      'node_modules/.pnpm/semver@7.6.0/node_modules/semver/index.js'(j, e) {
        var t = V(),
          a = J(),
          r = H(),
          n = W(),
          o = q(),
          i = Z(),
          s = X(),
          l = Y(),
          c = Q(),
          u = ee(),
          d = te(),
          p = ae(),
          h = re(),
          m = G(),
          f = ne(),
          g = oe(),
          v = ie(),
          b = se(),
          y = le(),
          S = ce(),
          k = ue(),
          w = de(),
          E = pe(),
          C = he(),
          N = me(),
          x = fe(),
          I = ge(),
          L = ye(),
          O = K(),
          T = Se(),
          A = ke(),
          P = we(),
          M = Ee(),
          _ = Ce(),
          R = Ne(),
          D = xe(),
          $ = Ie(),
          z = Le(),
          U = Oe(),
          B = Te(),
          F = Ae();
        e.exports = {
          parse: o,
          valid: i,
          clean: s,
          inc: l,
          diff: c,
          major: u,
          minor: d,
          patch: p,
          prerelease: h,
          compare: m,
          rcompare: f,
          compareLoose: g,
          compareBuild: v,
          sort: b,
          rsort: y,
          gt: S,
          lt: k,
          eq: w,
          neq: E,
          gte: C,
          lte: N,
          cmp: x,
          coerce: I,
          Comparator: L,
          Range: O,
          satisfies: T,
          toComparators: A,
          maxSatisfying: P,
          minSatisfying: M,
          minVersion: _,
          validRange: R,
          outside: D,
          gtr: $,
          ltr: z,
          intersects: U,
          simplifyRange: B,
          subset: F,
          SemVer: r,
          re: t.re,
          src: t.src,
          tokens: t.t,
          SEMVER_SPEC_VERSION: a.SEMVER_SPEC_VERSION,
          RELEASE_TYPES: a.RELEASE_TYPES,
          compareIdentifiers: n.compareIdentifiers,
          rcompareIdentifiers: n.rcompareIdentifiers,
        };
      },
    }),
    Pe = e({
      'node_modules/.pnpm/chroma-js@2.4.2/node_modules/chroma-js/chroma.js'(e, t) {
        var a;
        (a = function () {
          'use strict';
          for (
            var e = function (e, t, a) {
                return void 0 === a && (a = 1), e < (t = void 0 === t ? 0 : t) ? t : a < e ? a : e;
              },
              j = e,
              D = {},
              t = 0,
              $ = ['Boolean', 'Number', 'String', 'Function', 'Array', 'Date', 'RegExp', 'Undefined', 'Null'];
            t < $.length;
            t += 1
          ) {
            var z = $[t];
            D['[object ' + z + ']'] = z.toLowerCase();
          }
          function a(e) {
            return D[Object.prototype.toString.call(e)] || 'object';
          }
          function U() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            if ('object' === Z(e[0]) && e[0].constructor && e[0].constructor === this.constructor) return e[0];
            var a = !1;
            if (!(o = J(e))) {
              (a = !0),
                s.sorted ||
                  ((s.autodetect = s.autodetect.sort(function (e, t) {
                    return t.p - e.p;
                  })),
                  (s.sorted = !0));
              for (var r = 0, n = s.autodetect; r < n.length; r += 1) {
                var o,
                  i = n[r];
                if ((o = i.test.apply(i, e))) break;
              }
            }
            if (!s.format[o]) throw new Error('unknown format: ' + e);
            (a = s.format[o].apply(null, a ? e : e.slice(0, -1))),
              (this._rgb = W(a)),
              3 === this._rgb.length && this._rgb.push(1);
          }
          function r() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            return new (Function.prototype.bind.apply(r.Color, [null].concat(e)))();
          }
          function B() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var a = (e = Q(e, 'cmyk'))[0],
              r = e[1],
              n = e[2],
              o = e[3],
              i = 4 < e.length ? e[4] : 1;
            return 1 === o
              ? [0, 0, 0, i]
              : [
                  1 <= a ? 0 : 255 * (1 - a) * (1 - o),
                  1 <= r ? 0 : 255 * (1 - r) * (1 - o),
                  1 <= n ? 0 : 255 * (1 - n) * (1 - o),
                  i,
                ];
          }
          function n(e) {
            return Math.round(100 * e) / 100;
          }
          function F() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var a,
              r,
              n = (e = ie(e, 'rgba'))[0],
              o = e[1],
              i = e[2],
              s = ((n /= 255), (o /= 255), (i /= 255), Math.min(n, o, i)),
              l = Math.max(n, o, i),
              c = (l + s) / 2;
            return (
              l === s ? ((a = 0), (r = Number.NaN)) : (a = c < 0.5 ? (l - s) / (l + s) : (l - s) / (2 - l - s)),
              n == l
                ? (r = (o - i) / (l - s))
                : o == l
                  ? (r = 2 + (i - n) / (l - s))
                  : i == l && (r = 4 + (n - o) / (l - s)),
              (r *= 60) < 0 && (r += 360),
              3 < e.length && void 0 !== e[3] ? [r, a, c, e[3]] : [r, a, c]
            );
          }
          function V() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var a = se(e, 'rgba'),
              r = le(e) || 'rgb';
            return 'hsl' == r.substr(0, 3)
              ? ce(ue(a), r)
              : ((a[0] = de(a[0])),
                (a[1] = de(a[1])),
                (a[2] = de(a[2])),
                ('rgba' === r || (3 < a.length && a[3] < 1)) && ((a[3] = 3 < a.length ? a[3] : 1), (r = 'rgba')),
                r + '(' + a.slice(0, 'rgb' === r ? 3 : 4).join(',') + ')');
          }
          function H() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var a,
              r,
              n,
              o = (e = pe(e, 'hsl'))[0],
              i = e[1],
              s = e[2];
            if (0 === i) a = r = n = 255 * s;
            else {
              var l = [0, 0, 0],
                c = [0, 0, 0],
                u = s < 0.5 ? s * (1 + i) : s + i - s * i,
                d = 2 * s - u,
                i = o / 360;
              (l[0] = i + 1 / 3), (l[1] = i), (l[2] = i - 1 / 3);
              for (var p = 0; p < 3; p++)
                l[p] < 0 && (l[p] += 1),
                  1 < l[p] && --l[p],
                  (c[p] =
                    6 * l[p] < 1
                      ? d + 6 * (u - d) * l[p]
                      : 2 * l[p] < 1
                        ? u
                        : 3 * l[p] < 2
                          ? d + (u - d) * (2 / 3 - l[p]) * 6
                          : d);
              (a = (s = [he(255 * c[0]), he(255 * c[1]), he(255 * c[2])])[0]), (r = s[1]), (n = s[2]);
            }
            return 3 < e.length ? [a, r, n, e[3]] : [a, r, n, 1];
          }
          function q(e) {
            var t, a;
            if (((e = e.toLowerCase().trim()), fe.format.named))
              try {
                return fe.format.named(e);
              } catch (e) {}
            if ((t = e.match(ge))) {
              for (var r = t.slice(1, 4), n = 0; n < 3; n++) r[n] = +r[n];
              return (r[3] = 1), r;
            }
            if ((t = e.match(ve))) {
              for (var o = t.slice(1, 5), i = 0; i < 4; i++) o[i] = +o[i];
              return o;
            }
            if ((t = e.match(be))) {
              for (var s = t.slice(1, 4), l = 0; l < 3; l++) s[l] = we(2.55 * s[l]);
              return (s[3] = 1), s;
            }
            if ((t = e.match(ye))) {
              for (var c = t.slice(1, 5), u = 0; u < 3; u++) c[u] = we(2.55 * c[u]);
              return (c[3] = +c[3]), c;
            }
            return (t = e.match(Se))
              ? (((a = t.slice(1, 4))[1] *= 0.01), (a[2] *= 0.01), ((a = me(a))[3] = 1), a)
              : (t = e.match(ke))
                ? (((a = t.slice(1, 4))[1] *= 0.01), (a[2] *= 0.01), ((e = me(a))[3] = +t[4]), e)
                : void 0;
          }
          var G = a,
            K = a,
            o = Math.PI,
            e = {
              clip_rgb: function (e) {
                (e._clipped = !1), (e._unclipped = e.slice(0));
                for (var t = 0; t <= 3; t++)
                  t < 3
                    ? ((e[t] < 0 || 255 < e[t]) && (e._clipped = !0), (e[t] = j(e[t], 0, 255)))
                    : 3 === t && (e[t] = j(e[t], 0, 1));
                return e;
              },
              limit: e,
              type: a,
              unpack: function (t, e) {
                return (
                  void 0 === e && (e = null),
                  3 <= t.length
                    ? Array.prototype.slice.call(t)
                    : 'object' == G(t[0]) && e
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
                return !(e.length < 2) && ((t = e.length - 1), 'string' == K(e[t])) ? e[t].toLowerCase() : null;
              },
              PI: o,
              TWOPI: 2 * o,
              PITHIRD: o / 3,
              DEG2RAD: o / 180,
              RAD2DEG: 180 / o,
            },
            o = { format: {}, autodetect: [] },
            J = e.last,
            W = e.clip_rgb,
            Z = e.type,
            s = o,
            i =
              ((U.prototype.toString = function () {
                return 'function' == Z(this.hex) ? this.hex() : '[' + this._rgb.join(',') + ']';
              }),
              U),
            l = ((r.Color = i), (r.version = '2.4.2'), r),
            X = e.unpack,
            Y = Math.max,
            Q = e.unpack,
            c = l,
            ee = i,
            u = o,
            te = e.unpack,
            ae = e.type,
            re = function () {
              for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
              var a = X(e, 'rgb'),
                r = a[0],
                n = a[1],
                a = a[2],
                o = 1 - Y((r /= 255), Y((n /= 255), (a /= 255))),
                i = o < 1 ? 1 / (1 - o) : 0;
              return [(1 - r - o) * i, (1 - n - o) * i, (1 - a - o) * i, o];
            },
            ne =
              ((ee.prototype.cmyk = function () {
                return re(this._rgb);
              }),
              (c.cmyk = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(ee, [null].concat(e, ['cmyk'])))();
              }),
              (u.format.cmyk = B),
              u.autodetect.push({
                p: 2,
                test: function () {
                  for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                  if (((e = te(e, 'cmyk')), 'array' === ae(e) && 4 === e.length)) return 'cmyk';
                },
              }),
              e.unpack),
            oe = e.last,
            ie = e.unpack,
            se = e.unpack,
            le = e.last,
            ce = function () {
              for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
              var a = ne(e, 'hsla'),
                r = oe(e) || 'lsa';
              return (
                (a[0] = n(a[0] || 0)),
                (a[1] = n(100 * a[1]) + '%'),
                (a[2] = n(100 * a[2]) + '%'),
                'hsla' === r || (3 < a.length && a[3] < 1)
                  ? ((a[3] = 3 < a.length ? a[3] : 1), (r = 'hsla'))
                  : (a.length = 3),
                r + '(' + a.join(',') + ')'
              );
            },
            ue = F,
            de = Math.round,
            pe = e.unpack,
            he = Math.round,
            me = H,
            fe = o,
            ge = /^rgb\(\s*(-?\d+),\s*(-?\d+)\s*,\s*(-?\d+)\s*\)$/,
            ve = /^rgba\(\s*(-?\d+),\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*([01]|[01]?\.\d+)\)$/,
            be = /^rgb\(\s*(-?\d+(?:\.\d+)?)%,\s*(-?\d+(?:\.\d+)?)%\s*,\s*(-?\d+(?:\.\d+)?)%\s*\)$/,
            ye =
              /^rgba\(\s*(-?\d+(?:\.\d+)?)%,\s*(-?\d+(?:\.\d+)?)%\s*,\s*(-?\d+(?:\.\d+)?)%\s*,\s*([01]|[01]?\.\d+)\)$/,
            Se = /^hsl\(\s*(-?\d+(?:\.\d+)?),\s*(-?\d+(?:\.\d+)?)%\s*,\s*(-?\d+(?:\.\d+)?)%\s*\)$/,
            ke =
              /^hsla\(\s*(-?\d+(?:\.\d+)?),\s*(-?\d+(?:\.\d+)?)%\s*,\s*(-?\d+(?:\.\d+)?)%\s*,\s*([01]|[01]?\.\d+)\)$/,
            we = Math.round;
          q.test = function (e) {
            return ge.test(e) || ve.test(e) || be.test(e) || ye.test(e) || Se.test(e) || ke.test(e);
          };
          function Ee() {
            for (var e, t = [], a = arguments.length; a--; ) t[a] = arguments[a];
            var r,
              n,
              o,
              i = (t = Ge(t, 'hcg'))[0],
              s = t[1],
              l = t[2],
              c = ((l *= 255), 255 * s);
            if (0 === s) r = n = o = l;
            else {
              360 < (i = 360 === i ? 0 : i) && (i -= 360), i < 0 && (i += 360);
              var u = Ke((i /= 60)),
                i = i - u,
                d = l * (1 - s),
                p = d + c * (1 - i),
                h = d + c * i,
                m = d + c;
              switch (u) {
                case 0:
                  (r = (e = [m, h, d])[0]), (n = e[1]), (o = e[2]);
                  break;
                case 1:
                  (r = (e = [p, m, d])[0]), (n = e[1]), (o = e[2]);
                  break;
                case 2:
                  (r = (e = [d, m, h])[0]), (n = e[1]), (o = e[2]);
                  break;
                case 3:
                  (r = (e = [d, p, m])[0]), (n = e[1]), (o = e[2]);
                  break;
                case 4:
                  (r = (e = [h, d, m])[0]), (n = e[1]), (o = e[2]);
                  break;
                case 5:
                  (r = (e = [m, d, p])[0]), (n = e[1]), (o = e[2]);
              }
            }
            return [r, n, o, 3 < t.length ? t[3] : 1];
          }
          function Ce() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var a = (o = Ye(e, 'rgba'))[0],
              r = o[1],
              n = o[2],
              o = o[3],
              i = Qe(e) || 'auto',
              s =
                (void 0 === o && (o = 1),
                'auto' === i && (i = o < 1 ? 'rgba' : 'rgb'),
                (s = '000000' + ((d(a) << 16) | (d(r) << 8) | d(n)).toString(16)).substr(s.length - 6)),
              l = (l = '0' + d(255 * o).toString(16)).substr(l.length - 2);
            switch (i.toLowerCase()) {
              case 'rgba':
                return '#' + s + l;
              case 'argb':
                return '#' + l + s;
              default:
                return '#' + s;
            }
          }
          function Ne(e) {
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
          function xe() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var a,
              r,
              n,
              o = (e = ut(e, 'hsi'))[0],
              i = e[1],
              s = e[2];
            return (
              isNaN(o) && (o = 0),
              isNaN(i) && (i = 0),
              360 < o && (o -= 360),
              o < 0 && (o += 360),
              (o /= 360) < 1 / 3
                ? (r = 1 - ((n = (1 - i) / 3) + (a = (1 + (i * h(p * o)) / h(pt - p * o)) / 3)))
                : o < 2 / 3
                  ? (n = 1 - ((a = (1 - i) / 3) + (r = (1 + (i * h(p * (o -= 1 / 3))) / h(pt - p * o)) / 3)))
                  : (a = 1 - ((r = (1 - i) / 3) + (n = (1 + (i * h(p * (o -= 2 / 3))) / h(pt - p * o)) / 3))),
              [255 * (a = dt(s * a * 3)), 255 * (r = dt(s * r * 3)), 255 * (n = dt(s * n * 3)), 3 < e.length ? e[3] : 1]
            );
          }
          function Ie() {
            for (var e, t = [], a = arguments.length; a--; ) t[a] = arguments[a];
            var r,
              n,
              o,
              i = (t = Ct(t, 'hsv'))[0],
              s = t[1],
              l = t[2];
            if (((l *= 255), 0 === s)) r = n = o = l;
            else {
              360 < (i = 360 === i ? 0 : i) && (i -= 360), i < 0 && (i += 360);
              var c = Nt((i /= 60)),
                i = i - c,
                u = l * (1 - s),
                d = l * (1 - s * i),
                p = l * (1 - s * (1 - i));
              switch (c) {
                case 0:
                  (r = (e = [l, p, u])[0]), (n = e[1]), (o = e[2]);
                  break;
                case 1:
                  (r = (e = [d, l, u])[0]), (n = e[1]), (o = e[2]);
                  break;
                case 2:
                  (r = (e = [u, l, p])[0]), (n = e[1]), (o = e[2]);
                  break;
                case 3:
                  (r = (e = [u, d, l])[0]), (n = e[1]), (o = e[2]);
                  break;
                case 4:
                  (r = (e = [p, u, l])[0]), (n = e[1]), (o = e[2]);
                  break;
                case 5:
                  (r = (e = [l, u, d])[0]), (n = e[1]), (o = e[2]);
              }
            }
            return [r, n, o, 3 < t.length ? t[3] : 1];
          }
          function Le() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var a = (n = Tt(e, 'rgb'))[0],
              r = n[1],
              n = n[2];
            return (
              (r = r),
              (n = n),
              (a = Pt((a = a))),
              (r = Pt(r)),
              (n = Pt(n)),
              [
                (n =
                  116 *
                    (r = (a = [
                      Mt((0.4124564 * a + 0.3575761 * r + 0.1804375 * n) / m.Xn),
                      Mt((0.2126729 * a + 0.7151522 * r + 0.072175 * n) / m.Yn),
                      Mt((0.0193339 * a + 0.119192 * r + 0.9503041 * n) / m.Zn),
                    ])[1]) -
                  16) < 0
                  ? 0
                  : n,
                500 * (a[0] - r),
                200 * (r - a[2]),
              ]
            );
          }
          function Oe(e) {
            return 255 * (e <= 0.00304 ? 12.92 * e : 1.055 * Rt(e, 1 / 2.4) - 0.055);
          }
          function Te(e) {
            return e > f.t1 ? e * e * e : f.t2 * (e - f.t0);
          }
          function Ae() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var a = (e = _t(e, 'lab'))[0],
              r = e[1],
              n = e[2],
              a = (a + 16) / 116,
              r = isNaN(r) ? a : a + r / 500,
              n = isNaN(n) ? a : a - n / 200;
            return (
              (a = f.Yn * Te(a)),
              (r = f.Xn * Te(r)),
              (n = f.Zn * Te(n)),
              [
                Oe(3.2404542 * r - 1.5371385 * a - 0.4985314 * n),
                Oe(-0.969266 * r + 1.8760108 * a + 0.041556 * n),
                Oe(0.0556434 * r - 0.2040259 * a + 1.0572252 * n),
                3 < e.length ? e[3] : 1,
              ]
            );
          }
          function Pe() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var a = (n = Ut(e, 'lab'))[0],
              r = n[1],
              n = n[2],
              o = Ft(r * r + n * n),
              n = (Vt(n, r) * Bt + 360) % 360;
            return [a, o, (n = 0 === Ht(1e4 * o) ? Number.NaN : n)];
          }
          function Me() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var a = (n = Jt(e, 'lch'))[0],
              r = n[1],
              n = n[2];
            return isNaN(n) && (n = 0), [a, Xt((n *= Wt)) * r, Zt(n) * r];
          }
          function _e() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var a = (e = Yt(e, 'lch'))[0],
              r = e[1],
              n = e[2],
              r = (a = Qt(a, r, n))[0],
              n = a[1],
              a = a[2];
            return [(r = ea(r, n, a))[0], r[1], r[2], 3 < e.length ? e[3] : 1];
          }
          function Re() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var a = ta(e, 'hcl').reverse();
            return aa.apply(void 0, a);
          }
          function je(e) {
            if ('number' == da(e) && 0 <= e && e <= 16777215) return [e >> 16, (e >> 8) & 255, 255 & e, 1];
            throw new Error('unknown num color: ' + e);
          }
          function De(e) {
            var t,
              a,
              r =
                (e = e / 100) < 66
                  ? ((t = 255),
                    (a =
                      e < 6 ? 0 : -155.25485562709179 - 0.44596950469579133 * (a = e - 2) + 104.49216199393888 * S(a)),
                    e < 20 ? 0 : 0.8274096064007395 * (r = e - 10) - 254.76935184120902 + 115.67994401066147 * S(r))
                  : ((t = 351.97690566805693 + 0.114206453784165 * (t = e - 55) - 40.25366309332127 * S(t)),
                    (a = 325.4494125711974 + 0.07943456536662342 * (a = e - 50) - 28.0852963507957 * S(a)),
                    255);
            return [t, a, r, 1];
          }
          function $e() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var a = (n = Ea(e, 'rgb'))[0],
              r = n[1],
              n = n[2],
              a = [Ia(a / 255), Ia(r / 255), Ia(n / 255)],
              o = Ca(0.4122214708 * (r = a[0]) + 0.5363325363 * (n = a[1]) + 0.0514459929 * (a = a[2])),
              i = Ca(0.2119034982 * r + 0.6806995451 * n + 0.1073969566 * a),
              r = Ca(0.0883024619 * r + 0.2817188376 * n + 0.6299787005 * a);
            return [
              0.2104542553 * o + 0.793617785 * i - 0.0040720468 * r,
              1.9779984951 * o - 2.428592205 * i + 0.4505937099 * r,
              0.0259040371 * o + 0.7827717662 * i - 0.808675766 * r,
            ];
          }
          var c = l,
            ze = i,
            u = o,
            Ue = e.type,
            Be = V,
            Fe = q,
            Ve =
              ((ze.prototype.css = function (e) {
                return Be(this._rgb, e);
              }),
              (c.css = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(ze, [null].concat(e, ['css'])))();
              }),
              (u.format.css = Fe),
              u.autodetect.push({
                p: 5,
                test: function (e) {
                  for (var t = [], a = arguments.length - 1; 0 < a--; ) t[a] = arguments[a + 1];
                  if (!t.length && 'string' === Ue(e) && Fe.test(e)) return 'css';
                },
              }),
              i),
            c = l,
            u = o,
            He = e.unpack,
            qe =
              ((u.format.gl = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                var a = He(e, 'rgba');
                return (a[0] *= 255), (a[1] *= 255), (a[2] *= 255), a;
              }),
              (c.gl = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(Ve, [null].concat(e, ['gl'])))();
              }),
              (Ve.prototype.gl = function () {
                var e = this._rgb;
                return [e[0] / 255, e[1] / 255, e[2] / 255, e[3]];
              }),
              e.unpack),
            Ge = e.unpack,
            Ke = Math.floor,
            Je = e.unpack,
            We = e.type,
            u = l,
            Ze = i,
            c = o,
            Xe = function () {
              for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
              var a,
                r = qe(e, 'rgb'),
                n = r[0],
                o = r[1],
                r = r[2],
                i = Math.min(n, o, r),
                s = Math.max(n, o, r),
                l = s - i;
              return (
                0 == l
                  ? (a = Number.NaN)
                  : (n === s && (a = (o - r) / l),
                    o === s && (a = 2 + (r - n) / l),
                    r === s && (a = 4 + (n - o) / l),
                    (a *= 60) < 0 && (a += 360)),
                [a, (100 * l) / 255, (i / (255 - l)) * 100]
              );
            },
            Ye =
              ((Ze.prototype.hcg = function () {
                return Xe(this._rgb);
              }),
              (u.hcg = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(Ze, [null].concat(e, ['hcg'])))();
              }),
              (c.format.hcg = Ee),
              c.autodetect.push({
                p: 1,
                test: function () {
                  for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                  if (((e = Je(e, 'hcg')), 'array' === We(e) && 3 === e.length)) return 'hcg';
                },
              }),
              e.unpack),
            Qe = e.last,
            d = Math.round,
            et = /^#?([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/,
            tt = /^#?([A-Fa-f0-9]{8}|[A-Fa-f0-9]{4})$/,
            u = l,
            at = i,
            rt = e.type,
            c = o,
            nt = Ce,
            ot =
              ((at.prototype.hex = function (e) {
                return nt(this._rgb, e);
              }),
              (u.hex = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(at, [null].concat(e, ['hex'])))();
              }),
              (c.format.hex = Ne),
              c.autodetect.push({
                p: 4,
                test: function (e) {
                  for (var t = [], a = arguments.length - 1; 0 < a--; ) t[a] = arguments[a + 1];
                  if (!t.length && 'string' === rt(e) && 0 <= [3, 4, 5, 6, 7, 8, 9].indexOf(e.length)) return 'hex';
                },
              }),
              e.unpack),
            it = e.TWOPI,
            st = Math.min,
            lt = Math.sqrt,
            ct = Math.acos,
            ut = e.unpack,
            dt = e.limit,
            p = e.TWOPI,
            pt = e.PITHIRD,
            h = Math.cos,
            ht = e.unpack,
            mt = e.type,
            u = l,
            ft = i,
            c = o,
            gt = function () {
              for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
              var a,
                r = ot(e, 'rgb'),
                n = r[0],
                o = r[1],
                r = r[2],
                i = st((n /= 255), (o /= 255), (r /= 255)),
                s = (n + o + r) / 3,
                i = 0 < s ? 1 - i / s : 0;
              return (
                0 == i
                  ? (a = NaN)
                  : ((a = (n - o + (n - r)) / 2),
                    (a /= lt((n - o) * (n - o) + (n - r) * (o - r))),
                    (a = ct(a)),
                    o < r && (a = it - a),
                    (a /= it)),
                [360 * a, i, s]
              );
            },
            vt =
              ((ft.prototype.hsi = function () {
                return gt(this._rgb);
              }),
              (u.hsi = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(ft, [null].concat(e, ['hsi'])))();
              }),
              (c.format.hsi = xe),
              c.autodetect.push({
                p: 2,
                test: function () {
                  for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                  if (((e = ht(e, 'hsi')), 'array' === mt(e) && 3 === e.length)) return 'hsi';
                },
              }),
              e.unpack),
            bt = e.type,
            u = l,
            yt = i,
            c = o,
            St = F,
            kt =
              ((yt.prototype.hsl = function () {
                return St(this._rgb);
              }),
              (u.hsl = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(yt, [null].concat(e, ['hsl'])))();
              }),
              (c.format.hsl = H),
              c.autodetect.push({
                p: 2,
                test: function () {
                  for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                  if (((e = vt(e, 'hsl')), 'array' === bt(e) && 3 === e.length)) return 'hsl';
                },
              }),
              e.unpack),
            wt = Math.min,
            Et = Math.max,
            Ct = e.unpack,
            Nt = Math.floor,
            xt = e.unpack,
            It = e.type,
            u = l,
            Lt = i,
            c = o,
            Ot = function () {
              for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
              var a,
                r,
                n = (e = kt(e, 'rgb'))[0],
                o = e[1],
                i = e[2],
                s = wt(n, o, i),
                l = Et(n, o, i),
                s = l - s;
              return (
                0 === l
                  ? ((a = Number.NaN), (r = 0))
                  : ((r = s / l),
                    n === l && (a = (o - i) / s),
                    o === l && (a = 2 + (i - n) / s),
                    i === l && (a = 4 + (n - o) / s),
                    (a *= 60) < 0 && (a += 360)),
                [a, r, l / 255]
              );
            },
            u =
              ((Lt.prototype.hsv = function () {
                return Ot(this._rgb);
              }),
              (u.hsv = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(Lt, [null].concat(e, ['hsv'])))();
              }),
              (c.format.hsv = Ie),
              c.autodetect.push({
                p: 2,
                test: function () {
                  for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                  if (((e = xt(e, 'hsv')), 'array' === It(e) && 3 === e.length)) return 'hsv';
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
            m = u,
            Tt = e.unpack,
            At = Math.pow,
            Pt = function (e) {
              return (e /= 255) <= 0.04045 ? e / 12.92 : At((e + 0.055) / 1.055, 2.4);
            },
            Mt = function (e) {
              return e > m.t3 ? At(e, 1 / 3) : e / m.t2 + m.t0;
            },
            f = u,
            _t = e.unpack,
            Rt = Math.pow,
            jt = e.unpack,
            Dt = e.type,
            c = l,
            $t = i,
            g = o,
            zt = Le,
            Ut =
              (($t.prototype.lab = function () {
                return zt(this._rgb);
              }),
              (c.lab = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply($t, [null].concat(e, ['lab'])))();
              }),
              (g.format.lab = Ae),
              g.autodetect.push({
                p: 2,
                test: function () {
                  for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                  if (((e = jt(e, 'lab')), 'array' === Dt(e) && 3 === e.length)) return 'lab';
                },
              }),
              e.unpack),
            Bt = e.RAD2DEG,
            Ft = Math.sqrt,
            Vt = Math.atan2,
            Ht = Math.round,
            qt = e.unpack,
            Gt = Le,
            Kt = Pe,
            Jt = e.unpack,
            Wt = e.DEG2RAD,
            Zt = Math.sin,
            Xt = Math.cos,
            Yt = e.unpack,
            Qt = Me,
            ea = Ae,
            ta = e.unpack,
            aa = _e,
            ra = e.unpack,
            na = e.type,
            c = l,
            v = i,
            oa = o,
            ia = function () {
              for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
              var a = qt(e, 'rgb'),
                r = a[0],
                n = a[1],
                a = a[2],
                r = Gt(r, n, a),
                n = r[0],
                a = r[1],
                r = r[2];
              return Kt(n, a, r);
            },
            g =
              ((v.prototype.lch = function () {
                return ia(this._rgb);
              }),
              (v.prototype.hcl = function () {
                return ia(this._rgb).reverse();
              }),
              (c.lch = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(v, [null].concat(e, ['lch'])))();
              }),
              (c.hcl = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(v, [null].concat(e, ['hcl'])))();
              }),
              (oa.format.lch = _e),
              (oa.format.hcl = Re),
              ['lch', 'hcl'].forEach(function (a) {
                return oa.autodetect.push({
                  p: 2,
                  test: function () {
                    for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                    if (((e = ra(e, a)), 'array' === na(e) && 3 === e.length)) return a;
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
            c = i,
            b = o,
            sa = e.type,
            y = g,
            la = Ne,
            ca = Ce,
            ua =
              ((c.prototype.name = function () {
                for (var e = ca(this._rgb, 'rgb'), t = 0, a = Object.keys(y); t < a.length; t += 1) {
                  var r = a[t];
                  if (y[r] === e) return r.toLowerCase();
                }
                return e;
              }),
              (b.format.named = function (e) {
                if (((e = e.toLowerCase()), y[e])) return la(y[e]);
                throw new Error('unknown color name: ' + e);
              }),
              b.autodetect.push({
                p: 5,
                test: function (e) {
                  for (var t = [], a = arguments.length - 1; 0 < a--; ) t[a] = arguments[a + 1];
                  if (!t.length && 'string' === sa(e) && y[e.toLowerCase()]) return 'named';
                },
              }),
              e.unpack),
            da = e.type,
            c = l,
            pa = i,
            b = o,
            ha = e.type,
            ma = function () {
              for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
              var a = ua(e, 'rgb');
              return (a[0] << 16) + (a[1] << 8) + a[2];
            },
            c =
              ((pa.prototype.num = function () {
                return ma(this._rgb);
              }),
              (c.num = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(pa, [null].concat(e, ['num'])))();
              }),
              (b.format.num = je),
              b.autodetect.push({
                p: 5,
                test: function () {
                  for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                  if (1 === e.length && 'number' === ha(e[0]) && 0 <= e[0] && e[0] <= 16777215) return 'num';
                },
              }),
              l),
            fa = i,
            b = o,
            ga = e.unpack,
            va = e.type,
            ba = Math.round,
            S =
              ((fa.prototype.rgb = function (e) {
                return !1 === (e = void 0 === e ? !0 : e) ? this._rgb.slice(0, 3) : this._rgb.slice(0, 3).map(ba);
              }),
              (fa.prototype.rgba = function (a) {
                return (
                  void 0 === a && (a = !0),
                  this._rgb.slice(0, 4).map(function (e, t) {
                    return !(t < 3) || !1 === a ? e : ba(e);
                  })
                );
              }),
              (c.rgb = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(fa, [null].concat(e, ['rgb'])))();
              }),
              (b.format.rgb = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                var a = ga(e, 'rgba');
                return void 0 === a[3] && (a[3] = 1), a;
              }),
              b.autodetect.push({
                p: 3,
                test: function () {
                  for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                  if (
                    ((e = ga(e, 'rgba')),
                    'array' === va(e) &&
                      (3 === e.length || (4 === e.length && 'number' == va(e[3]) && 0 <= e[3] && e[3] <= 1)))
                  )
                    return 'rgb';
                },
              }),
              Math.log),
            ya = De,
            Sa = e.unpack,
            ka = Math.round,
            c = l,
            k = i,
            b = o,
            wa = function () {
              for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
              for (var a = Sa(e, 'rgb'), r = a[0], n = a[2], o = 1e3, i = 4e4; 0.4 < i - o; ) {
                var s,
                  l = ya((s = 0.5 * (i + o)));
                l[2] / l[0] >= n / r ? (i = s) : (o = s);
              }
              return ka(s);
            },
            Ea =
              ((k.prototype.temp =
                k.prototype.kelvin =
                k.prototype.temperature =
                  function () {
                    return wa(this._rgb);
                  }),
              (c.temp =
                c.kelvin =
                c.temperature =
                  function () {
                    for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                    return new (Function.prototype.bind.apply(k, [null].concat(e, ['temp'])))();
                  }),
              (b.format.temp = b.format.kelvin = b.format.temperature = De),
              e.unpack),
            Ca = Math.cbrt,
            Na = Math.pow,
            xa = Math.sign;
          function Ia(e) {
            var t = Math.abs(e);
            return t < 0.04045 ? e / 12.92 : (xa(e) || 1) * Na((t + 0.055) / 1.055, 2.4);
          }
          function La() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var a = (e = Oa(e, 'lab'))[0],
              r = e[1],
              n = e[2],
              o = w(a + 0.3963377774 * r + 0.2158037573 * n, 3),
              i = w(a - 0.1055613458 * r - 0.0638541728 * n, 3),
              a = w(a - 0.0894841775 * r - 1.291485548 * n, 3);
            return [
              255 * Aa(4.0767416621 * o - 3.3077115913 * i + 0.2309699292 * a),
              255 * Aa(-1.2684380046 * o + 2.6097574011 * i - 0.3413193965 * a),
              255 * Aa(-0.0041960863 * o - 0.7034186147 * i + 1.707614701 * a),
              3 < e.length ? e[3] : 1,
            ];
          }
          var Oa = e.unpack,
            w = Math.pow,
            Ta = Math.sign;
          function Aa(e) {
            var t = Math.abs(e);
            return 0.0031308 < t ? (Ta(e) || 1) * (1.055 * w(t, 1 / 2.4) - 0.055) : 12.92 * e;
          }
          function Pa() {
            for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
            var a = (e = Ua(e, 'lch'))[0],
              r = e[1],
              n = e[2],
              r = (a = Ba(a, r, n))[0],
              n = a[1],
              a = a[2];
            return [(r = Fa(r, n, a))[0], r[1], r[2], 3 < e.length ? e[3] : 1];
          }
          var Ma = e.unpack,
            _a = e.type,
            c = l,
            Ra = i,
            b = o,
            ja = $e,
            Da =
              ((Ra.prototype.oklab = function () {
                return ja(this._rgb);
              }),
              (c.oklab = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(Ra, [null].concat(e, ['oklab'])))();
              }),
              (b.format.oklab = La),
              b.autodetect.push({
                p: 3,
                test: function () {
                  for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                  if (((e = Ma(e, 'oklab')), 'array' === _a(e) && 3 === e.length)) return 'oklab';
                },
              }),
              e.unpack),
            $a = $e,
            za = Pe,
            Ua = e.unpack,
            Ba = Me,
            Fa = La,
            Va = e.unpack,
            Ha = e.type,
            c = l,
            qa = i,
            b = o,
            Ga = function () {
              for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
              var a = Da(e, 'rgb'),
                r = a[0],
                n = a[1],
                a = a[2],
                r = $a(r, n, a),
                n = r[0],
                a = r[1],
                r = r[2];
              return za(n, a, r);
            },
            Ka =
              ((qa.prototype.oklch = function () {
                return Ga(this._rgb);
              }),
              (c.oklch = function () {
                for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                return new (Function.prototype.bind.apply(qa, [null].concat(e, ['oklch'])))();
              }),
              (b.format.oklch = Pa),
              b.autodetect.push({
                p: 3,
                test: function () {
                  for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
                  if (((e = Va(e, 'oklch')), 'array' === Ha(e) && 3 === e.length)) return 'oklch';
                },
              }),
              i),
            Ja = e.type;
          Ka.prototype.alpha = function (e, t) {
            return (
              void 0 === t && (t = !1),
              void 0 !== e && 'number' === Ja(e)
                ? t
                  ? ((this._rgb[3] = e), this)
                  : new Ka([this._rgb[0], this._rgb[1], this._rgb[2], e], 'rgb')
                : this._rgb[3]
            );
          };
          i.prototype.clipped = function () {
            return this._rgb._clipped || !1;
          };
          var E = i,
            Wa = u;
          (E.prototype.darken = function (e) {
            void 0 === e && (e = 1);
            var t = this.lab();
            return (t[0] -= Wa.Kn * e), new E(t, 'lab').alpha(this.alpha(), !0);
          }),
            (E.prototype.brighten = function (e) {
              return this.darken(-(e = void 0 === e ? 1 : e));
            }),
            (E.prototype.darker = E.prototype.darken),
            (E.prototype.brighter = E.prototype.brighten);
          function Za(e, t, a) {
            void 0 === a && (a = 0.5);
            for (var r = [], n = arguments.length - 3; 0 < n--; ) r[n] = arguments[n + 3];
            var o = r[0] || 'lrgb';
            if ((x[o] || r.length || (o = Object.keys(x)[0]), x[o]))
              return (
                'object' !== nr(e) && (e = new rr(e)),
                'object' !== nr(t) && (t = new rr(t)),
                x[o](e, t, a).alpha(e.alpha() + a * (t.alpha() - e.alpha()))
              );
            throw new Error('interpolation mode ' + o + ' is not defined');
          }
          function C(e, t, a, r) {
            var n, o, i, s, l, c, u, d, p, h;
            return (
              'hsl' === r
                ? ((h = e.hsl()), (n = t.hsl()))
                : 'hsv' === r
                  ? ((h = e.hsv()), (n = t.hsv()))
                  : 'hcg' === r
                    ? ((h = e.hcg()), (n = t.hcg()))
                    : 'hsi' === r
                      ? ((h = e.hsi()), (n = t.hsi()))
                      : 'lch' === r || 'hcl' === r
                        ? ((r = 'hcl'), (h = e.hcl()), (n = t.hcl()))
                        : 'oklch' === r && ((h = e.oklch().reverse()), (n = t.oklch().reverse())),
              ('h' !== r.substr(0, 1) && 'oklch' !== r) ||
                ((o = (e = h)[0]), (s = e[1]), (c = e[2]), (i = (t = n)[0]), (l = t[1]), (u = t[2])),
              isNaN(o) || isNaN(i)
                ? isNaN(o)
                  ? isNaN(i)
                    ? (p = Number.NaN)
                    : ((p = i), (1 != c && 0 != c) || 'hsv' == r || (d = l))
                  : ((p = o), (1 != u && 0 != u) || 'hsv' == r || (d = s))
                : (p = o + a * (o < i && 180 < i - o ? i - (o + 360) : i < o && 180 < o - i ? i + 360 - o : i - o)),
              void 0 === d && (d = s + a * (l - s)),
              (h = c + a * (u - c)),
              new fr('oklch' === r ? [h, d, p] : [p, d, h], r)
            );
          }
          function Xa(e, t, a) {
            return gr(e, t, a, 'lch');
          }
          function Ya(c) {
            function a(e) {
              if (
                ((e = e || ['#fff', '#000']) &&
                  'string' === O(e) &&
                  L.brewer &&
                  L.brewer[e.toLowerCase()] &&
                  (e = L.brewer[e.toLowerCase()]),
                'array' === O(e))
              ) {
                e = (e = 1 === e.length ? [e[0], e[0]] : e).slice(0);
                for (var t = 0; t < e.length; t++) e[t] = L(e[t]);
                for (var a = (l.length = 0); a < e.length; a++) l.push(a / (e.length - 1));
              }
              r(), (f = e);
            }
            function u(e, t) {
              var a, r;
              if ((null == t && (t = !1), isNaN(e) || null === e)) return s;
              if (
                ((r = t ? e : m && 2 < m.length ? k(e) / (m.length - 2) : v !== g ? (e - g) / (v - g) : 1),
                (r = E(r)),
                t || (r = w(r)),
                1 !== S && (r = Pr(r, S)),
                (r = h[0] + r * (1 - h[0] - h[1])),
                (r = Math.min(1, Math.max(0, r))),
                (e = Math.floor(1e4 * r)),
                y && b[e])
              )
                a = b[e];
              else {
                if ('array' === O(f))
                  for (var n = 0; n < l.length; n++) {
                    var o = l[n];
                    if (r <= o) {
                      a = f[n];
                      break;
                    }
                    if (o <= r && n === l.length - 1) {
                      a = f[n];
                      break;
                    }
                    if (o < r && r < l[n + 1]) {
                      (r = (r - o) / (l[n + 1] - o)), (a = L.interpolate(f[n], f[n + 1], r, i));
                      break;
                    }
                  }
                else 'function' === O(f) && (a = f(r));
                y && (b[e] = a);
              }
              return a;
            }
            function r() {
              b = {};
            }
            function d(e) {
              return (e = L(u(e))), n && e[n] ? e[n]() : e;
            }
            var i = 'rgb',
              s = L('#ccc'),
              t = 0,
              p = [0, 1],
              l = [],
              h = [0, 0],
              m = !1,
              f = [],
              n = !1,
              g = 0,
              v = 1,
              b = {},
              y = !0,
              S = 1,
              k = function (e) {
                if (null == m) return 0;
                for (var t = m.length - 1, a = 0; a < t && e >= m[a]; ) a++;
                return a - 1;
              },
              w = function (e) {
                return e;
              },
              E = function (e) {
                return e;
              };
            return (
              a(c),
              (d.classes = function (e) {
                var t;
                return null != e
                  ? ('array' === O(e)
                      ? (p = [(m = e)[0], e[e.length - 1]])
                      : ((t = L.analyze(p)), (m = 0 === e ? [t.min, t.max] : L.limits(t, 'e', e))),
                    d)
                  : m;
              }),
              (d.domain = function (a) {
                if (!arguments.length) return p;
                (g = a[0]), (v = a[a.length - 1]), (l = []);
                var e = f.length;
                if (a.length === e && g !== v)
                  for (var t = 0, r = Array.from(a); t < r.length; t += 1) {
                    var n = r[t];
                    l.push((n - g) / (v - g));
                  }
                else {
                  for (var o, i, s = 0; s < e; s++) l.push(s / (e - 1));
                  2 < a.length &&
                    ((o = a.map(function (e, t) {
                      return t / (a.length - 1);
                    })),
                    (i = a.map(function (e) {
                      return (e - g) / (v - g);
                    })).every(function (e, t) {
                      return o[t] === e;
                    }) ||
                      (E = function (e) {
                        if (e <= 0 || 1 <= e) return e;
                        for (var t = 0; e >= i[t + 1]; ) t++;
                        var a = (e - i[t]) / (i[t + 1] - i[t]);
                        return o[t] + a * (o[t + 1] - o[t]);
                      }));
                }
                return (p = [g, v]), d;
              }),
              (d.mode = function (e) {
                return arguments.length ? ((i = e), r(), d) : i;
              }),
              (d.range = function (e, t) {
                return a(e), d;
              }),
              (d.out = function (e) {
                return (n = e), d;
              }),
              (d.spread = function (e) {
                return arguments.length ? ((t = e), d) : t;
              }),
              (d.correctLightness = function (e) {
                return (
                  r(),
                  (w = (e = null == e ? !0 : e)
                    ? function (e) {
                        for (
                          var t = u(0, !0).lab()[0],
                            a = u(1, !0).lab()[0],
                            r = a < t,
                            n = u(e, !0).lab()[0],
                            o = t + (a - t) * e,
                            i = n - o,
                            s = 0,
                            l = 1,
                            c = 20;
                          0.01 < Math.abs(i) && 0 < c--;

                        )
                          r && (i *= -1),
                            (e += i < 0 ? 0.5 * (l - (s = e)) : 0.5 * (s - (l = e))),
                            (n = u(e, !0).lab()[0]),
                            (i = n - o);
                        return e;
                      }
                    : function (e) {
                        return e;
                      }),
                  d
                );
              }),
              (d.padding = function (e) {
                return null != e ? ('number' === O(e) && (e = [e, e]), (h = e), d) : h;
              }),
              (d.colors = function (t, a) {
                arguments.length < 2 && (a = 'hex');
                var e = [];
                if (0 === arguments.length) e = f.slice(0);
                else if (1 === t) e = [d(0.5)];
                else if (1 < t)
                  var r = p[0],
                    n = p[1] - r,
                    e = (function (e, t, a) {
                      for (
                        var r = [], n = e < t, o = a ? (n ? t + 1 : t - 1) : t, i = e;
                        n ? i < o : o < i;
                        n ? i++ : i--
                      )
                        r.push(i);
                      return r;
                    })(0, t, !1).map(function (e) {
                      return d(r + (e / (t - 1)) * n);
                    });
                else {
                  c = [];
                  var o = [];
                  if (m && 2 < m.length)
                    for (var i = 1, s = m.length, l = 1 <= s; l ? i < s : s < i; l ? i++ : i--)
                      o.push(0.5 * (m[i - 1] + m[i]));
                  else o = p;
                  e = o.map(d);
                }
                return (e = L[a]
                  ? e.map(function (e) {
                      return e[a]();
                    })
                  : e);
              }),
              (d.cache = function (e) {
                return null != e ? ((y = e), d) : y;
              }),
              (d.gamma = function (e) {
                return null != e ? ((S = e), d) : S;
              }),
              (d.nodata = function (e) {
                return null != e ? ((s = L(e)), d) : s;
              }),
              d
            );
          }
          i.prototype.get = function (e) {
            var e = e.split('.'),
              t = e[0],
              e = e[1],
              a = this[t]();
            if (e) {
              var r = t.indexOf(e) - ('ok' === t.substr(0, 2) ? 2 : 0);
              if (-1 < r) return a[r];
              throw new Error('unknown channel ' + e + ' in mode ' + t);
            }
            return a;
          };
          var N = i,
            Qa = e.type,
            er = Math.pow,
            tr =
              ((N.prototype.luminance = function (n) {
                var o, i, s, e;
                return void 0 !== n && 'number' === Qa(n)
                  ? 0 === n
                    ? new N([0, 0, 0, this._rgb[3]], 'rgb')
                    : 1 === n
                      ? new N([255, 255, 255, this._rgb[3]], 'rgb')
                      : ((e = this.luminance()),
                        (o = 'rgb'),
                        (i = 20),
                        (s = function (e, t) {
                          var a = e.interpolate(t, 0.5, o),
                            r = a.luminance();
                          return Math.abs(n - r) < 1e-7 || !i-- ? a : n < r ? s(e, a) : s(a, t);
                        }),
                        (e = (n < e ? s(new N([0, 0, 0]), this) : s(this, new N([255, 255, 255]))).rgb()),
                        new N(e.concat([this._rgb[3]])))
                  : tr.apply(void 0, this._rgb.slice(0, 3));
              }),
              function (e, t, a) {
                return 0.2126 * (e = ar(e)) + 0.7152 * (t = ar(t)) + 0.0722 * (a = ar(a));
              }),
            ar = function (e) {
              return (e /= 255) <= 0.03928 ? e / 12.92 : er((e + 0.055) / 1.055, 2.4);
            },
            o = {},
            rr = i,
            nr = e.type,
            x = o,
            c = i,
            or = Za,
            ir =
              ((c.prototype.mix = c.prototype.interpolate =
                function (e, t) {
                  void 0 === t && (t = 0.5);
                  for (var a = [], r = arguments.length - 2; 0 < r--; ) a[r] = arguments[r + 2];
                  return or.apply(void 0, [this, e, t].concat(a));
                }),
              i),
            sr =
              ((ir.prototype.premultiply = function (e) {
                var t = this._rgb,
                  a = t[3];
                return (e = void 0 === e ? !1 : e)
                  ? ((this._rgb = [t[0] * a, t[1] * a, t[2] * a, a]), this)
                  : new ir([t[0] * a, t[1] * a, t[2] * a, a], 'rgb');
              }),
              i),
            lr = u,
            cr =
              ((sr.prototype.saturate = function (e) {
                void 0 === e && (e = 1);
                var t = this.lch();
                return (t[1] += lr.Kn * e), t[1] < 0 && (t[1] = 0), new sr(t, 'lch').alpha(this.alpha(), !0);
              }),
              (sr.prototype.desaturate = function (e) {
                return this.saturate(-(e = void 0 === e ? 1 : e));
              }),
              i),
            ur = e.type,
            dr =
              ((cr.prototype.set = function (e, t, a) {
                void 0 === a && (a = !1);
                var e = e.split('.'),
                  r = e[0],
                  e = e[1],
                  n = this[r]();
                if (e) {
                  var o = r.indexOf(e) - ('ok' === r.substr(0, 2) ? 2 : 0);
                  if (-1 < o) {
                    if ('string' == ur(t))
                      switch (t.charAt(0)) {
                        case '+':
                        case '-':
                          n[o] += +t;
                          break;
                        case '*':
                          n[o] *= +t.substr(1);
                          break;
                        case '/':
                          n[o] /= +t.substr(1);
                          break;
                        default:
                          n[o] = +t;
                      }
                    else {
                      if ('number' !== ur(t)) throw new Error('unsupported value for Color.set');
                      n[o] = t;
                    }
                    var i = new cr(n, r);
                    return a ? ((this._rgb = i._rgb), this) : i;
                  }
                  throw new Error('unknown channel ' + e + ' in mode ' + r);
                }
                return n;
              }),
              i),
            pr =
              ((o.rgb = function (e, t, a) {
                (e = e._rgb), (t = t._rgb);
                return new dr(e[0] + a * (t[0] - e[0]), e[1] + a * (t[1] - e[1]), e[2] + a * (t[2] - e[2]), 'rgb');
              }),
              i),
            hr = Math.sqrt,
            I = Math.pow,
            mr =
              ((o.lrgb = function (e, t, a) {
                var e = e._rgb,
                  r = e[0],
                  n = e[1],
                  e = e[2],
                  t = t._rgb,
                  o = t[0],
                  i = t[1],
                  t = t[2];
                return new pr(
                  hr(I(r, 2) * (1 - a) + I(o, 2) * a),
                  hr(I(n, 2) * (1 - a) + I(i, 2) * a),
                  hr(I(e, 2) * (1 - a) + I(t, 2) * a),
                  'rgb',
                );
              }),
              i),
            fr =
              ((o.lab = function (e, t, a) {
                (e = e.lab()), (t = t.lab());
                return new mr(e[0] + a * (t[0] - e[0]), e[1] + a * (t[1] - e[1]), e[2] + a * (t[2] - e[2]), 'lab');
              }),
              i),
            gr = C,
            vr = ((o.lch = Xa), (o.hcl = Xa), i),
            br =
              ((o.num = function (e, t, a) {
                (e = e.num()), (t = t.num());
                return new vr(e + a * (t - e), 'num');
              }),
              C),
            yr =
              ((o.hcg = function (e, t, a) {
                return br(e, t, a, 'hcg');
              }),
              C),
            Sr =
              ((o.hsi = function (e, t, a) {
                return yr(e, t, a, 'hsi');
              }),
              C),
            kr =
              ((o.hsl = function (e, t, a) {
                return Sr(e, t, a, 'hsl');
              }),
              C),
            wr =
              ((o.hsv = function (e, t, a) {
                return kr(e, t, a, 'hsv');
              }),
              i),
            Er =
              ((o.oklab = function (e, t, a) {
                (e = e.oklab()), (t = t.oklab());
                return new wr(e[0] + a * (t[0] - e[0]), e[1] + a * (t[1] - e[1]), e[2] + a * (t[2] - e[2]), 'oklab');
              }),
              C),
            Cr =
              ((o.oklch = function (e, t, a) {
                return Er(e, t, a, 'oklch');
              }),
              i),
            Nr = e.clip_rgb,
            xr = Math.pow,
            Ir = Math.sqrt,
            Lr = Math.PI,
            Or = Math.cos,
            Tr = Math.sin,
            Ar = Math.atan2,
            L = l,
            O = e.type,
            Pr = Math.pow;
          for (
            var T = i,
              Mr = Ya,
              _r = function (e) {
                for (var t = [1, 1], a = 1; a < e; a++) {
                  for (var r = [1], n = 1; n <= t.length; n++) r[n] = (t[n] || 0) + t[n - 1];
                  t = r;
                }
                return t;
              },
              Rr = l,
              A = function (e, t, a) {
                if (A[a]) return A[a](e, t);
                throw new Error('unknown blend mode ' + a);
              },
              b = function (a) {
                return function (e, t) {
                  (t = Rr(t).rgb()), (e = Rr(e).rgb());
                  return Rr.rgb(a(t, e));
                };
              },
              c = function (r) {
                return function (e, t) {
                  var a = [];
                  return (a[0] = r(e[0], t[0])), (a[1] = r(e[1], t[1])), (a[2] = r(e[2], t[2])), a;
                };
              },
              u =
                ((A.normal = b(
                  c(function (e) {
                    return e;
                  }),
                )),
                (A.multiply = b(
                  c(function (e, t) {
                    return (e * t) / 255;
                  }),
                )),
                (A.screen = b(
                  c(function (e, t) {
                    return 255 * (1 - (1 - e / 255) * (1 - t / 255));
                  }),
                )),
                (A.overlay = b(
                  c(function (e, t) {
                    return t < 128 ? (2 * e * t) / 255 : 255 * (1 - 2 * (1 - e / 255) * (1 - t / 255));
                  }),
                )),
                (A.darken = b(
                  c(function (e, t) {
                    return t < e ? t : e;
                  }),
                )),
                (A.lighten = b(
                  c(function (e, t) {
                    return t < e ? e : t;
                  }),
                )),
                (A.dodge = b(
                  c(function (e, t) {
                    return 255 === e || 255 < (e = ((t / 255) * 255) / (1 - e / 255)) ? 255 : e;
                  }),
                )),
                (A.burn = b(
                  c(function (e, t) {
                    return 255 * (1 - (1 - t / 255) / (e / 255));
                  }),
                )),
                A),
              jr = e.type,
              Dr = e.clip_rgb,
              $r = e.TWOPI,
              zr = Math.pow,
              Ur = Math.sin,
              Br = Math.cos,
              Fr = l,
              Vr = i,
              Hr = Math.floor,
              qr = Math.random,
              Gr = a,
              Kr = Math.log,
              Jr = Math.pow,
              Wr = Math.floor,
              Zr = Math.abs,
              Xr = function (e, t) {
                void 0 === t && (t = null);
                var a = { min: Number.MAX_VALUE, max: -1 * Number.MAX_VALUE, sum: 0, values: [], count: 0 };
                return (
                  (e = 'object' === Gr(e) ? Object.values(e) : e).forEach(function (e) {
                    null == (e = t && 'object' === Gr(e) ? e[t] : e) ||
                      isNaN(e) ||
                      (a.values.push(e),
                      (a.sum += e),
                      e < a.min && (a.min = e),
                      a.max < e && (a.max = e),
                      (a.count += 1));
                  }),
                  (a.domain = [a.min, a.max]),
                  (a.limits = function (e, t) {
                    return Yr(a, e, t);
                  }),
                  a
                );
              },
              Yr = function (e, t, a) {
                void 0 === t && (t = 'equal'), void 0 === a && (a = 7);
                var r = (e = 'array' == Gr(e) ? Xr(e) : e).min,
                  n = e.max,
                  o = e.values.sort(function (e, t) {
                    return e - t;
                  });
                if (1 === a) return [r, n];
                var i = [];
                if (('c' === t.substr(0, 1) && (i.push(r), i.push(n)), 'e' === t.substr(0, 1))) {
                  i.push(r);
                  for (var s = 1; s < a; s++) i.push(r + (s / a) * (n - r));
                  i.push(n);
                } else if ('l' === t.substr(0, 1)) {
                  if (r <= 0) throw new Error('Logarithmic scales are only possible for values > 0');
                  var l = Math.LOG10E * Kr(r),
                    j = Math.LOG10E * Kr(n);
                  i.push(r);
                  for (var c = 1; c < a; c++) i.push(Jr(10, l + (c / a) * (j - l)));
                  i.push(n);
                } else if ('q' === t.substr(0, 1)) {
                  i.push(r);
                  for (var u = 1; u < a; u++) {
                    var d = ((o.length - 1) * u) / a,
                      p = Wr(d);
                    i.push(p === d ? o[p] : o[p] * (1 - (d = d - p)) + o[p + 1] * d);
                  }
                  i.push(n);
                } else if ('k' === t.substr(0, 1)) {
                  var h,
                    m = o.length,
                    f = new Array(m),
                    g = new Array(a),
                    v = !0,
                    D = 0,
                    b = null;
                  (b = []).push(r);
                  for (var y = 1; y < a; y++) b.push(r + (y / a) * (n - r));
                  for (b.push(n); v; ) {
                    for (var S = 0; S < a; S++) g[S] = 0;
                    for (var k = 0; k < m; k++)
                      for (var $ = o[k], z = Number.MAX_VALUE, w = void 0, E = 0; E < a; E++) {
                        var U = Zr(b[E] - $);
                        U < z && ((z = U), (w = E)), g[w]++, (f[k] = w);
                      }
                    for (var C = new Array(a), N = 0; N < a; N++) C[N] = null;
                    for (var x = 0; x < m; x++) null === C[(h = f[x])] ? (C[h] = o[x]) : (C[h] += o[x]);
                    for (var I = 0; I < a; I++) C[I] *= 1 / g[I];
                    for (var v = !1, L = 0; L < a; L++)
                      if (C[L] !== b[L]) {
                        v = !0;
                        break;
                      }
                    (b = C), 200 < ++D && (v = !1);
                  }
                  for (var O = {}, T = 0; T < a; T++) O[T] = [];
                  for (var A = 0; A < m; A++) O[(h = f[A])].push(o[A]);
                  for (var P = [], M = 0; M < a; M++) P.push(O[M][0]), P.push(O[M][O[M].length - 1]);
                  (P = P.sort(function (e, t) {
                    return e - t;
                  })),
                    i.push(P[0]);
                  for (var _ = 1; _ < P.length; _ += 2) {
                    var R = P[_];
                    isNaN(R) || -1 !== i.indexOf(R) || i.push(R);
                  }
                }
                return i;
              },
              o = Xr,
              b = Yr,
              Qr = i,
              en = i,
              P = Math.sqrt,
              M = Math.pow,
              tn = Math.min,
              an = Math.max,
              rn = Math.atan2,
              nn = Math.abs,
              _ = Math.cos,
              on = Math.sin,
              sn = Math.exp,
              ln = Math.PI,
              cn = i,
              un = i,
              dn = l,
              pn = Ya,
              c = {
                cool: function () {
                  return pn([dn.hsl(180, 1, 0.9), dn.hsl(250, 0.7, 0.4)]);
                },
                hot: function () {
                  return pn(['#000', '#f00', '#ff0', '#fff']).mode('rgb');
                },
              },
              R = {
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
              hn = 0,
              mn = Object.keys(R);
            hn < mn.length;
            hn += 1
          ) {
            var fn = mn[hn];
            R[fn.toLowerCase()] = R[fn];
          }
          (e = R), (i = l);
          return (
            (i.average = function (e, o, i) {
              void 0 === o && (o = 'lrgb'), void 0 === i && (i = null);
              var t = e.length,
                a =
                  t /
                  (i =
                    i ||
                    Array.from(new Array(t)).map(function () {
                      return 1;
                    })).reduce(function (e, t) {
                    return e + t;
                  });
              if (
                (i.forEach(function (e, t) {
                  i[t] *= a;
                }),
                (e = e.map(function (e) {
                  return new Cr(e);
                })),
                'lrgb' === o)
              ) {
                for (var r = e, n = i, s = r.length, l = [0, 0, 0, 0], c = 0; c < r.length; c++) {
                  var u = r[c];
                  var d = n[c] / s;
                  u = u._rgb;
                  l[0] += xr(u[0], 2) * d;
                  l[1] += xr(u[1], 2) * d;
                  l[2] += xr(u[2], 2) * d;
                  l[3] += u[3] * d;
                }
                if (((l[0] = Ir(l[0])), (l[1] = Ir(l[1])), (l[2] = Ir(l[2])), l[3] > 0.9999999)) l[3] = 1;
                return new Cr(Nr(l));
              }
              for (var p, h = e.shift(), m = h.get(o), f = [], g = 0, v = 0, b = 0; b < m.length; b++)
                (m[b] = (m[b] || 0) * i[0]),
                  f.push(isNaN(m[b]) ? 0 : i[0]),
                  'h' !== o.charAt(b) ||
                    isNaN(m[b]) ||
                    ((p = (m[b] / 180) * Lr), (g += Or(p) * i[0]), (v += Tr(p) * i[0]));
              var y = h.alpha() * i[0];
              e.forEach(function (e, t) {
                var a = e.get(o);
                y += e.alpha() * i[t + 1];
                for (var r, n = 0; n < m.length; n++)
                  isNaN(a[n]) ||
                    ((f[n] += i[t + 1]),
                    'h' === o.charAt(n)
                      ? ((r = (a[n] / 180) * Lr), (g += Or(r) * i[t + 1]), (v += Tr(r) * i[t + 1]))
                      : (m[n] += a[n] * i[t + 1]));
              });
              for (var S = 0; S < m.length; S++)
                if ('h' === o.charAt(S)) {
                  for (var k = (Ar(v / f[S], g / f[S]) / Lr) * 180; k < 0; ) k += 360;
                  for (; 360 <= k; ) k -= 360;
                  m[S] = k;
                } else m[S] = m[S] / f[S];
              return (y /= t), new Cr(m, o).alpha(0.99999 < y ? 1 : y, !0);
            }),
            (i.bezier = function (e) {
              var t = (function (e) {
                if (
                  2 ===
                  (e = e.map(function (e) {
                    return new T(e);
                  })).length
                )
                  (i = e.map(function (e) {
                    return e.lab();
                  })),
                    (a = i[0]),
                    (r = i[1]),
                    (i = function (t) {
                      var e = [0, 1, 2].map(function (e) {
                        return a[e] + t * (r[e] - a[e]);
                      });
                      return new T(e, 'lab');
                    });
                else if (3 === e.length)
                  (t = e.map(function (e) {
                    return e.lab();
                  })),
                    (a = t[0]),
                    (r = t[1]),
                    (n = t[2]),
                    (i = function (t) {
                      var e = [0, 1, 2].map(function (e) {
                        return (1 - t) * (1 - t) * a[e] + 2 * (1 - t) * t * r[e] + t * t * n[e];
                      });
                      return new T(e, 'lab');
                    });
                else if (4 === e.length)
                  var t,
                    a = (t = e.map(function (e) {
                      return e.lab();
                    }))[0],
                    r = t[1],
                    n = t[2],
                    o = t[3],
                    i = function (t) {
                      var e = [0, 1, 2].map(function (e) {
                        return (
                          (1 - t) * (1 - t) * (1 - t) * a[e] +
                          3 * (1 - t) * (1 - t) * t * r[e] +
                          3 * (1 - t) * t * t * n[e] +
                          t * t * t * o[e]
                        );
                      });
                      return new T(e, 'lab');
                    };
                else {
                  if (!(5 <= e.length)) throw new RangeError('No point in running bezier with only one color.');
                  var s = e.map(function (e) {
                      return e.lab();
                    }),
                    l = e.length - 1,
                    c = _r(l);
                  i = function (n) {
                    var o = 1 - n,
                      e = [0, 1, 2].map(function (r) {
                        return s.reduce(function (e, t, a) {
                          return e + c[a] * Math.pow(o, l - a) * Math.pow(n, a) * t[r];
                        }, 0);
                      });
                    return new T(e, 'lab');
                  };
                }
                return i;
              })(e);
              return (
                (t.scale = function () {
                  return Mr(t);
                }),
                t
              );
            }),
            (i.blend = u),
            (i.cubehelix = function (n, o, i, s, l) {
              void 0 === n && (n = 300), void 0 === o && (o = -1.5), void 0 === i && (i = 1), void 0 === s && (s = 1);
              function t(e) {
                var t = $r * ((n + 120) / 360 + o * e),
                  a = zr(l[0] + c * e, s),
                  e = ((0 !== u ? i[0] + e * u : i) * a * (1 - a)) / 2,
                  r = Br(t),
                  t = Ur(t);
                return Fr(
                  Dr([
                    255 * (a + e * (-0.14861 * r + 1.78277 * t)),
                    255 * (a + e * (-0.29227 * r - 0.90649 * t)),
                    255 * (a + 1.97294 * r * e),
                    1,
                  ]),
                );
              }
              var c,
                u = 0;
              'array' === jr((l = void 0 === l ? [0, 1] : l)) ? (c = l[1] - l[0]) : ((c = 0), (l = [l, l]));
              return (
                (t.start = function (e) {
                  return null == e ? n : ((n = e), t);
                }),
                (t.rotations = function (e) {
                  return null == e ? o : ((o = e), t);
                }),
                (t.gamma = function (e) {
                  return null == e ? s : ((s = e), t);
                }),
                (t.hue = function (e) {
                  return null == e ? i : ('array' === jr((i = e)) ? 0 === (u = i[1] - i[0]) && (i = i[1]) : (u = 0), t);
                }),
                (t.lightness = function (e) {
                  return null == e ? l : ((c = 'array' === jr(e) ? (l = e)[1] - e[0] : ((l = [e, e]), 0)), t);
                }),
                (t.scale = function () {
                  return Fr.scale(t);
                }),
                t.hue(i),
                t
              );
            }),
            (i.mix = i.interpolate = Za),
            (i.random = function () {
              for (var e = '#', t = 0; t < 6; t++) e += '0123456789abcdef'.charAt(Hr(16 * qr()));
              return new Vr(e, 'hex');
            }),
            (i.scale = Ya),
            (i.analyze = o),
            (i.contrast = function (e, t) {
              (e = new Qr(e)), (t = new Qr(t));
              (e = e.luminance()), (t = t.luminance());
              return t < e ? (e + 0.05) / (t + 0.05) : (t + 0.05) / (e + 0.05);
            }),
            (i.deltaE = function (e, t, a, r, n) {
              void 0 === a && (a = 1), void 0 === r && (r = 1), void 0 === n && (n = 1);
              function o(e) {
                return (360 * e) / (2 * ln);
              }
              function i(e) {
                return (2 * ln * e) / 360;
              }
              (e = new en(e)), (t = new en(t));
              var e = Array.from(e.lab()),
                s = e[0],
                l = e[1],
                e = e[2],
                t = Array.from(t.lab()),
                c = t[0],
                u = t[1],
                t = t[2],
                d = (s + c) / 2,
                p = (P(M(l, 2) + M(e, 2)) + P(M(u, 2) + M(t, 2))) / 2,
                p = 0.5 * (1 - P(M(p, 7) / (M(p, 7) + M(25, 7)))),
                l = l * (1 + p),
                u = u * (1 + p),
                p = P(M(l, 2) + M(e, 2)),
                h = P(M(u, 2) + M(t, 2)),
                m = (p + h) / 2,
                e = o(rn(e, l)),
                l = o(rn(t, u)),
                t = 0 <= e ? e : e + 360,
                u = 0 <= l ? l : l + 360,
                e = 180 < nn(t - u) ? (t + u + 360) / 2 : (t + u) / 2,
                l = 1 - 0.17 * _(i(e - 30)) + 0.24 * _(i(2 * e)) + 0.32 * _(i(3 * e + 6)) - 0.2 * _(i(4 * e - 63)),
                f = nn((f = u - t)) <= 180 ? f : u <= t ? 360 + f : f - 360,
                u = ((f = 2 * P(p * h) * on(i(f) / 2)), c - s),
                t = h - p,
                c = 1 + (0.015 * M(d - 50, 2)) / P(20 + M(d - 50, 2)),
                s = 1 + 0.045 * m,
                h = 1 + 0.015 * m * l,
                p = 30 * sn(-M((e - 275) / 25, 2)),
                d = -(2 * P(M(m, 7) / (M(m, 7) + M(25, 7)))) * on(2 * i(p)),
                l = P(M(u / (a * c), 2) + M(t / (r * s), 2) + M(f / (n * h), 2) + (t / (r * s)) * d * (f / (n * h)));
              return an(0, tn(100, l));
            }),
            (i.distance = function (e, t, a) {
              void 0 === a && (a = 'lab'), (e = new cn(e)), (t = new cn(t));
              var r,
                n = e.get(a),
                o = t.get(a),
                i = 0;
              for (r in n) {
                var s = (n[r] || 0) - (o[r] || 0);
                i += s * s;
              }
              return Math.sqrt(i);
            }),
            (i.limits = b),
            (i.valid = function () {
              for (var e = [], t = arguments.length; t--; ) e[t] = arguments[t];
              try {
                return new (Function.prototype.bind.apply(un, [null].concat(e)))(), !0;
              } catch (e) {
                return !1;
              }
            }),
            (i.scales = c),
            (i.colors = g),
            (i.brewer = e),
            i
          );
        }),
          'object' == typeof (e = e) && void 0 !== t
            ? (t.exports = a())
            : 'function' == typeof define && define.amd
              ? define(a)
              : ((e = 'undefined' != typeof globalThis ? globalThis : e || self).chroma = a());
      },
    }),
    Me = e({
      'node_modules/.pnpm/react-simple-code-editor@0.13.1_react-dom@18.2.0_react@18.2.0/node_modules/react-simple-code-editor/lib/index.js'(
        e,
      ) {
        'use strict';
        var r,
          t,
          a =
            (e && e.__extends) ||
            ((r = function (e, t) {
              return (r =
                Object.setPrototypeOf ||
                ({ __proto__: [] } instanceof Array
                  ? function (e, t) {
                      e.__proto__ = t;
                    }
                  : function (e, t) {
                      for (var a in t) Object.prototype.hasOwnProperty.call(t, a) && (e[a] = t[a]);
                    }))(e, t);
            }),
            function (e, t) {
              if ('function' != typeof t && null !== t)
                throw new TypeError('Class extends value ' + String(t) + ' is not a constructor or null');
              function a() {
                this.constructor = e;
              }
              r(e, t), (e.prototype = null === t ? Object.create(t) : ((a.prototype = t.prototype), new a()));
            }),
          w =
            (e && e.__assign) ||
            function () {
              return (w =
                Object.assign ||
                function (e) {
                  for (var t, a = 1, r = arguments.length; a < r; a++)
                    for (var n in (t = arguments[a])) Object.prototype.hasOwnProperty.call(t, n) && (e[n] = t[n]);
                  return e;
                }).apply(this, arguments);
            },
          n =
            (e && e.__createBinding) ||
            (Object.create
              ? function (e, t, a, r) {
                  void 0 === r && (r = a);
                  var n = Object.getOwnPropertyDescriptor(t, a);
                  (n && ('get' in n ? t.__esModule : !n.writable && !n.configurable)) ||
                    (n = {
                      enumerable: !0,
                      get: function () {
                        return t[a];
                      },
                    }),
                    Object.defineProperty(e, r, n);
                }
              : function (e, t, a, r) {
                  e[(r = void 0 === r ? a : r)] = t[a];
                }),
          o =
            (e && e.__setModuleDefault) ||
            (Object.create
              ? function (e, t) {
                  Object.defineProperty(e, 'default', { enumerable: !0, value: t });
                }
              : function (e, t) {
                  e.default = t;
                }),
          i =
            (e && e.__importStar) ||
            function (e) {
              if (e && e.__esModule) return e;
              var t = {};
              if (null != e)
                for (var a in e) 'default' !== a && Object.prototype.hasOwnProperty.call(e, a) && n(t, e, a);
              return o(t, e), t;
            },
          E =
            (e && e.__rest) ||
            function (e, t) {
              var a = {};
              for (n in e) Object.prototype.hasOwnProperty.call(e, n) && t.indexOf(n) < 0 && (a[n] = e[n]);
              if (null != e && 'function' == typeof Object.getOwnPropertySymbols)
                for (var r = 0, n = Object.getOwnPropertySymbols(e); r < n.length; r++)
                  t.indexOf(n[r]) < 0 && Object.prototype.propertyIsEnumerable.call(e, n[r]) && (a[n[r]] = e[n[r]]);
              return a;
            },
          C = (Object.defineProperty(e, '__esModule', { value: !0 }), i(b())),
          g = 'undefined' != typeof window && 'navigator' in window && /Win/i.test(navigator.platform),
          v =
            'undefined' != typeof window && 'navigator' in window && /(Mac|iPhone|iPod|iPad)/i.test(navigator.platform),
          N = 'npm__react-simple-code-editor__textarea',
          x = '\n/**\n * Reset the text fill color so that placeholder is visible\n */\n.'
            .concat(
              N,
              ":empty {\n  -webkit-text-fill-color: inherit !important;\n}\n\n/**\n * Hack to apply on some CSS on IE10 and IE11\n */\n@media all and (-ms-high-contrast: none), (-ms-high-contrast: active) {\n  /**\n    * IE doesn't support '-webkit-text-fill-color'\n    * So we use 'color: transparent' to make the text transparent on IE\n    * Unlike other browsers, it doesn't affect caret color in IE\n    */\n  .",
            )
            .concat(N, ' {\n    color: transparent !important;\n  }\n\n  .')
            .concat(
              N,
              '::selection {\n    background-color: #accef7 !important;\n    color: transparent !important;\n  }\n}\n',
            ),
          i =
            ((t = C.Component),
            a(s, t),
            (s.prototype.componentDidMount = function () {
              this._recordCurrentState();
            }),
            Object.defineProperty(s.prototype, 'session', {
              get: function () {
                return { history: this._history };
              },
              set: function (e) {
                this._history = e.history;
              },
              enumerable: !1,
              configurable: !0,
            }),
            (s.prototype.render = function () {
              var t = this,
                e = this.props,
                a = e.value,
                r = e.style,
                n = e.padding,
                o = e.highlight,
                i = e.textareaId,
                s = e.textareaClassName,
                l = e.autoFocus,
                c = e.disabled,
                u = e.form,
                d = e.maxLength,
                p = e.minLength,
                h = e.name,
                m = e.placeholder,
                f = e.readOnly,
                g = e.required,
                v = e.onClick,
                b = e.onFocus,
                y = e.onBlur,
                S = e.onKeyUp,
                k = (e.onKeyDown, e.onValueChange, e.tabSize, e.insertSpaces, e.ignoreTabKey, e.preClassName),
                e = E(e, [
                  'value',
                  'style',
                  'padding',
                  'highlight',
                  'textareaId',
                  'textareaClassName',
                  'autoFocus',
                  'disabled',
                  'form',
                  'maxLength',
                  'minLength',
                  'name',
                  'placeholder',
                  'readOnly',
                  'required',
                  'onClick',
                  'onFocus',
                  'onBlur',
                  'onKeyUp',
                  'onKeyDown',
                  'onValueChange',
                  'tabSize',
                  'insertSpaces',
                  'ignoreTabKey',
                  'preClassName',
                ]),
                n = {
                  paddingTop: 'object' == typeof n ? n.top : n,
                  paddingRight: 'object' == typeof n ? n.right : n,
                  paddingBottom: 'object' == typeof n ? n.bottom : n,
                  paddingLeft: 'object' == typeof n ? n.left : n,
                },
                o = o(a);
              return C.createElement(
                'div',
                w({}, e, { style: w(w({}, I.container), r) }),
                C.createElement(
                  'pre',
                  w(
                    { className: k, 'aria-hidden': 'true', style: w(w(w({}, I.editor), I.highlight), n) },
                    'string' == typeof o ? { dangerouslySetInnerHTML: { __html: o + '<br />' } } : { children: o },
                  ),
                ),
                C.createElement('textarea', {
                  ref: function (e) {
                    return (t._input = e);
                  },
                  style: w(w(w({}, I.editor), I.textarea), n),
                  className: N + (s ? ' '.concat(s) : ''),
                  id: i,
                  value: a,
                  onChange: this._handleChange,
                  onKeyDown: this._handleKeyDown,
                  onClick: v,
                  onKeyUp: S,
                  onFocus: b,
                  onBlur: y,
                  disabled: c,
                  form: u,
                  maxLength: d,
                  minLength: p,
                  name: h,
                  placeholder: m,
                  readOnly: f,
                  required: g,
                  autoFocus: l,
                  autoCapitalize: 'off',
                  autoComplete: 'off',
                  autoCorrect: 'off',
                  spellCheck: !1,
                  'data-gramm': !1,
                }),
                C.createElement('style', { dangerouslySetInnerHTML: { __html: x } }),
              );
            }),
            (s.defaultProps = { tabSize: 2, insertSpaces: !0, ignoreTabKey: !1, padding: 0 }),
            s);
        function s() {
          var f = (null !== t && t.apply(this, arguments)) || this;
          return (
            (f.state = { capture: !0 }),
            (f._recordCurrentState = function () {
              var e,
                t,
                a = f._input;
              a &&
                ((e = a.value),
                (t = a.selectionStart),
                (a = a.selectionEnd),
                f._recordChange({ value: e, selectionStart: t, selectionEnd: a }));
            }),
            (f._getLines = function (e, t) {
              return e.substring(0, t).split('\n');
            }),
            (f._recordChange = function (e, t) {
              void 0 === t && (t = !1);
              var a = f._history,
                r = a.stack,
                a = a.offset,
                a =
                  (r.length &&
                    -1 < a &&
                    ((f._history.stack = r.slice(0, a + 1)), 100 < (a = f._history.stack.length)) &&
                    ((f._history.stack = r.slice((r = a - 100), a)),
                    (f._history.offset = Math.max(f._history.offset - r, 0))),
                  Date.now());
              if (t) {
                var r = f._history.stack[f._history.offset];
                if (r && a - r.timestamp < 3e3) {
                  var t = /[^a-z0-9]([a-z0-9]+)$/i,
                    r = null == (r = f._getLines(r.value, r.selectionStart).pop()) ? void 0 : r.match(t),
                    n = null == (n = f._getLines(e.value, e.selectionStart).pop()) ? void 0 : n.match(t);
                  if (null != r && r[1] && null != (t = null == n ? void 0 : n[1]) && t.startsWith(r[1]))
                    return void (f._history.stack[f._history.offset] = w(w({}, e), { timestamp: a }));
                }
              }
              f._history.stack.push(w(w({}, e), { timestamp: a })), f._history.offset++;
            }),
            (f._updateInput = function (e) {
              var t = f._input;
              t &&
                ((t.value = e.value),
                (t.selectionStart = e.selectionStart),
                (t.selectionEnd = e.selectionEnd),
                f.props.onValueChange(e.value));
            }),
            (f._applyEdits = function (e) {
              var t = f._input,
                a = f._history.stack[f._history.offset];
              a &&
                t &&
                (f._history.stack[f._history.offset] = w(w({}, a), {
                  selectionStart: t.selectionStart,
                  selectionEnd: t.selectionEnd,
                })),
                f._recordChange(e),
                f._updateInput(e);
            }),
            (f._undoEdit = function () {
              var e = f._history,
                t = e.stack,
                e = e.offset,
                t = t[e - 1];
              t && (f._updateInput(t), (f._history.offset = Math.max(e - 1, 0)));
            }),
            (f._redoEdit = function () {
              var e = f._history,
                t = e.stack,
                e = e.offset,
                a = t[e + 1];
              a && (f._updateInput(a), (f._history.offset = Math.min(e + 1, t.length - 1)));
            }),
            (f._handleKeyDown = function (e) {
              var t,
                a,
                r,
                n,
                o,
                i,
                s,
                l,
                c,
                u,
                d = f.props,
                p = d.tabSize,
                h = d.insertSpaces,
                m = d.ignoreTabKey,
                d = d.onKeyDown;
              (d && (d(e), e.defaultPrevented)) ||
                (27 === e.keyCode && e.currentTarget.blur(),
                (t = (d = e.currentTarget).value),
                (a = d.selectionStart),
                (d = d.selectionEnd),
                (r = (h ? ' ' : '\t').repeat(p)),
                9 === e.keyCode && !m && f.state.capture
                  ? (e.preventDefault(),
                    e.shiftKey
                      ? ((n = (l = f._getLines(t, a)).length - 1),
                        (o = f._getLines(t, d).length - 1),
                        (h = t
                          .split('\n')
                          .map(function (e, t) {
                            return n <= t && t <= o && e.startsWith(r) ? e.substring(r.length) : e;
                          })
                          .join('\n')),
                        t !== h &&
                          ((u = l[n]),
                          f._applyEdits({
                            value: h,
                            selectionStart: null != u && u.startsWith(r) ? a - r.length : a,
                            selectionEnd: d - (t.length - h.length),
                          })))
                      : a !== d
                        ? ((i = (l = f._getLines(t, a)).length - 1),
                          (s = f._getLines(t, d).length - 1),
                          (u = l[i]),
                          f._applyEdits({
                            value: t
                              .split('\n')
                              .map(function (e, t) {
                                return i <= t && t <= s ? r + e : e;
                              })
                              .join('\n'),
                            selectionStart: u && /\S/.test(u) ? a + r.length : a,
                            selectionEnd: d + r.length * (s - i + 1),
                          }))
                        : ((c = a + r.length),
                          f._applyEdits({
                            value: t.substring(0, a) + r + t.substring(d),
                            selectionStart: c,
                            selectionEnd: c,
                          })))
                  : 8 === e.keyCode
                    ? ((p = a !== d),
                      t.substring(0, a).endsWith(r) &&
                        !p &&
                        (e.preventDefault(),
                        (c = a - r.length),
                        f._applyEdits({
                          value: t.substring(0, a - r.length) + t.substring(d),
                          selectionStart: c,
                          selectionEnd: c,
                        })))
                    : 13 === e.keyCode
                      ? a === d &&
                        null != (h = null == (m = f._getLines(t, a).pop()) ? void 0 : m.match(/^\s+/)) &&
                        h[0] &&
                        (e.preventDefault(),
                        (c = a + (l = '\n' + h[0]).length),
                        f._applyEdits({
                          value: t.substring(0, a) + l + t.substring(d),
                          selectionStart: c,
                          selectionEnd: c,
                        }))
                      : 57 === e.keyCode || 219 === e.keyCode || 222 === e.keyCode || 192 === e.keyCode
                        ? ((u = void 0),
                          57 === e.keyCode && e.shiftKey
                            ? (u = ['(', ')'])
                            : 219 === e.keyCode
                              ? (u = e.shiftKey ? ['{', '}'] : ['[', ']'])
                              : 222 === e.keyCode
                                ? (u = e.shiftKey ? ['"', '"'] : ["'", "'"])
                                : 192 !== e.keyCode || e.shiftKey || (u = ['`', '`']),
                          a !== d &&
                            u &&
                            (e.preventDefault(),
                            f._applyEdits({
                              value: t.substring(0, a) + u[0] + t.substring(a, d) + u[1] + t.substring(d),
                              selectionStart: a,
                              selectionEnd: d + 2,
                            })))
                        : (v ? e.metaKey && 90 === e.keyCode : e.ctrlKey && 90 === e.keyCode) &&
                            !e.shiftKey &&
                            !e.altKey
                          ? (e.preventDefault(), f._undoEdit())
                          : (v
                                ? e.metaKey && 90 === e.keyCode && e.shiftKey
                                : g
                                  ? e.ctrlKey && 89 === e.keyCode
                                  : e.ctrlKey && 90 === e.keyCode && e.shiftKey) && !e.altKey
                            ? (e.preventDefault(), f._redoEdit())
                            : 77 !== e.keyCode ||
                              !e.ctrlKey ||
                              (v && !e.shiftKey) ||
                              (e.preventDefault(),
                              f.setState(function (e) {
                                return { capture: !e.capture };
                              })));
            }),
            (f._handleChange = function (e) {
              var e = e.currentTarget,
                t = e.value,
                a = e.selectionStart,
                e = e.selectionEnd;
              f._recordChange({ value: t, selectionStart: a, selectionEnd: e }, !0), f.props.onValueChange(t);
            }),
            (f._history = { stack: [], offset: -1 }),
            (f._input = null),
            f
          );
        }
        e.default = i;
        var I = {
          container: {
            position: 'relative',
            textAlign: 'left',
            boxSizing: 'border-box',
            padding: 0,
            overflow: 'hidden',
          },
          textarea: {
            position: 'absolute',
            top: 0,
            left: 0,
            height: '100%',
            width: '100%',
            resize: 'none',
            color: 'inherit',
            overflow: 'hidden',
            MozOsxFontSmoothing: 'grayscale',
            WebkitFontSmoothing: 'antialiased',
            WebkitTextFillColor: 'transparent',
          },
          highlight: { position: 'relative', pointerEvents: 'none' },
          editor: {
            margin: 0,
            border: 0,
            background: 'none',
            boxSizing: 'inherit',
            display: 'inherit',
            fontFamily: 'inherit',
            fontSize: 'inherit',
            fontStyle: 'inherit',
            fontVariantLigatures: 'inherit',
            fontWeight: 'inherit',
            letterSpacing: 'inherit',
            lineHeight: 'inherit',
            tabSize: 'inherit',
            textIndent: 'inherit',
            textRendering: 'inherit',
            textTransform: 'inherit',
            whiteSpace: 'pre-wrap',
            wordBreak: 'keep-all',
            overflowWrap: 'break-word',
          },
        };
      },
    }),
    _e = e({
      'node_modules/.pnpm/prismjs@1.29.0/node_modules/prismjs/components/prism-core.js'(e, t) {
        var l,
          a,
          r,
          n,
          T,
          o =
            'undefined' != typeof window
              ? window
              : 'undefined' != typeof WorkerGlobalScope && self instanceof WorkerGlobalScope
                ? self
                : {},
          o =
            ((a = /(?:^|\s)lang(?:uage)?-([\w-]+)(?=\s|$)/i),
            (r = 0),
            (n = {}),
            (T = {
              manual: (l = o).Prism && l.Prism.manual,
              disableWorkerMessageHandler: l.Prism && l.Prism.disableWorkerMessageHandler,
              util: {
                encode: function e(t) {
                  return t instanceof A
                    ? new A(t.type, e(t.content), t.alias)
                    : Array.isArray(t)
                      ? t.map(e)
                      : t
                          .replace(/&/g, '&amp;')
                          .replace(/</g, '&lt;')
                          .replace(/\u00a0/g, ' ');
                },
                type: function (e) {
                  return Object.prototype.toString.call(e).slice(8, -1);
                },
                objId: function (e) {
                  return e.__id || Object.defineProperty(e, '__id', { value: ++r }), e.__id;
                },
                clone: function a(e, r) {
                  var n, t;
                  switch (((r = r || {}), T.util.type(e))) {
                    case 'Object':
                      if (((t = T.util.objId(e)), r[t])) return r[t];
                      for (var o in ((n = {}), (r[t] = n), e)) e.hasOwnProperty(o) && (n[o] = a(e[o], r));
                      return n;
                    case 'Array':
                      return ((t = T.util.objId(e)), r[t])
                        ? r[t]
                        : ((n = []),
                          (r[t] = n),
                          e.forEach(function (e, t) {
                            n[t] = a(e, r);
                          }),
                          n);
                    default:
                      return e;
                  }
                },
                getLanguage: function (e) {
                  for (; e; ) {
                    var t = a.exec(e.className);
                    if (t) return t[1].toLowerCase();
                    e = e.parentElement;
                  }
                  return 'none';
                },
                setLanguage: function (e, t) {
                  (e.className = e.className.replace(RegExp(a, 'gi'), '')), e.classList.add('language-' + t);
                },
                currentScript: function () {
                  if ('undefined' == typeof document) return null;
                  if ('currentScript' in document) return document.currentScript;
                  try {
                    throw new Error();
                  } catch (e) {
                    var t = (/at [^(\r\n]*\((.*):[^:]+:[^:]+\)$/i.exec(e.stack) || [])[1];
                    if (t) {
                      var a,
                        r = document.getElementsByTagName('script');
                      for (a in r) if (r[a].src == t) return r[a];
                    }
                    return null;
                  }
                },
                isActive: function (e, t, a) {
                  for (var r = 'no-' + t; e; ) {
                    var n = e.classList;
                    if (n.contains(t)) return !0;
                    if (n.contains(r)) return !1;
                    e = e.parentElement;
                  }
                  return !!a;
                },
              },
              languages: {
                plain: n,
                plaintext: n,
                text: n,
                txt: n,
                extend: function (e, t) {
                  var a,
                    r = T.util.clone(T.languages[e]);
                  for (a in t) r[a] = t[a];
                  return r;
                },
                insertBefore: function (a, e, t, r) {
                  var n,
                    o = (r = r || T.languages)[a],
                    i = {};
                  for (n in o)
                    if (o.hasOwnProperty(n)) {
                      if (n == e) for (var s in t) t.hasOwnProperty(s) && (i[s] = t[s]);
                      t.hasOwnProperty(n) || (i[n] = o[n]);
                    }
                  var l = r[a];
                  return (
                    (r[a] = i),
                    T.languages.DFS(T.languages, function (e, t) {
                      t === l && e != a && (this[e] = i);
                    }),
                    i
                  );
                },
                DFS: function e(t, a, r, n) {
                  n = n || {};
                  var o,
                    i,
                    s,
                    l = T.util.objId;
                  for (o in t)
                    t.hasOwnProperty(o) &&
                      (a.call(t, o, t[o], r || o),
                      (i = t[o]),
                      'Object' !== (s = T.util.type(i)) || n[l(i)]
                        ? 'Array' !== s || n[l(i)] || ((n[l(i)] = !0), e(i, a, o, n))
                        : ((n[l(i)] = !0), e(i, a, null, n)));
                },
              },
              plugins: {},
              highlightAll: function (e, t) {
                T.highlightAllUnder(document, e, t);
              },
              highlightAllUnder: function (e, t, a) {
                var r = {
                  callback: a,
                  container: e,
                  selector:
                    'code[class*="language-"], [class*="language-"] code, code[class*="lang-"], [class*="lang-"] code',
                };
                T.hooks.run('before-highlightall', r),
                  (r.elements = Array.prototype.slice.apply(r.container.querySelectorAll(r.selector))),
                  T.hooks.run('before-all-elements-highlight', r);
                for (var n, o = 0; (n = r.elements[o++]); ) T.highlightElement(n, !0 === t, r.callback);
              },
              highlightElement: function (e, t, a) {
                var r = T.util.getLanguage(e),
                  n = T.languages[r],
                  o = (T.util.setLanguage(e, r), e.parentElement);
                o && 'pre' === o.nodeName.toLowerCase() && T.util.setLanguage(o, r);
                var i = { element: e, language: r, grammar: n, code: e.textContent };
                function s(e) {
                  (i.highlightedCode = e),
                    T.hooks.run('before-insert', i),
                    (i.element.innerHTML = i.highlightedCode),
                    T.hooks.run('after-highlight', i),
                    T.hooks.run('complete', i),
                    a && a.call(i.element);
                }
                T.hooks.run('before-sanity-check', i),
                  (o = i.element.parentElement) &&
                    'pre' === o.nodeName.toLowerCase() &&
                    !o.hasAttribute('tabindex') &&
                    o.setAttribute('tabindex', '0'),
                  i.code
                    ? (T.hooks.run('before-highlight', i),
                      i.grammar
                        ? t && l.Worker
                          ? (((r = new Worker(T.filename)).onmessage = function (e) {
                              s(e.data);
                            }),
                            r.postMessage(JSON.stringify({ language: i.language, code: i.code, immediateClose: !0 })))
                          : s(T.highlight(i.code, i.grammar, i.language))
                        : s(T.util.encode(i.code)))
                    : (T.hooks.run('complete', i), a && a.call(i.element));
              },
              highlight: function (e, t, a) {
                e = { code: e, grammar: t, language: a };
                if ((T.hooks.run('before-tokenize', e), e.grammar))
                  return (
                    (e.tokens = T.tokenize(e.code, e.grammar)),
                    T.hooks.run('after-tokenize', e),
                    A.stringify(T.util.encode(e.tokens), e.language)
                  );
                throw new Error('The language "' + e.language + '" has no grammar.');
              },
              tokenize: function (e, t) {
                var a = t.rest;
                if (a) {
                  for (var r in a) t[r] = a[r];
                  delete t.rest;
                }
                for (
                  var n = new c(),
                    o =
                      (M(n, n.head, e),
                      !(function e(t, a, r, n, o, i) {
                        for (var s in r)
                          if (r.hasOwnProperty(s) && r[s]) {
                            var l = r[s];
                            l = Array.isArray(l) ? l : [l];
                            for (var c = 0; c < l.length; ++c) {
                              if (i && i.cause == s + ',' + c) return;
                              for (
                                var u,
                                  d = l[c],
                                  p = d.inside,
                                  h = !!d.lookbehind,
                                  m = !!d.greedy,
                                  f = d.alias,
                                  g =
                                    (m &&
                                      !d.pattern.global &&
                                      ((u = d.pattern.toString().match(/[imsuy]*$/)[0]),
                                      (d.pattern = RegExp(d.pattern.source, u + 'g'))),
                                    d.pattern || d),
                                  v = n.next,
                                  b = o;
                                v !== a.tail && !(i && b >= i.reach);
                                b += v.value.length, v = v.next
                              ) {
                                var y = v.value;
                                if (a.length > t.length) return;
                                if (!(y instanceof A)) {
                                  var S,
                                    k = 1;
                                  if (m) {
                                    if (!(S = P(g, b, t, h)) || S.index >= t.length) break;
                                    var w = S.index,
                                      E = S.index + S[0].length,
                                      C = b;
                                    for (C += v.value.length; C <= w; ) (v = v.next), (C += v.value.length);
                                    if (((C -= v.value.length), (b = C), v.value instanceof A)) continue;
                                    for (var N = v; N !== a.tail && (C < E || 'string' == typeof N.value); N = N.next)
                                      k++, (C += N.value.length);
                                    k--, (y = t.slice(b, C)), (S.index -= b);
                                  } else if (!(S = P(g, 0, y, h))) continue;
                                  var w = S.index,
                                    x = S[0],
                                    I = y.slice(0, w),
                                    L = y.slice(w + x.length),
                                    y = b + y.length,
                                    O = (i && y > i.reach && (i.reach = y), v.prev),
                                    I =
                                      (I && ((O = M(a, O, I)), (b += I.length)),
                                      _(a, O, k),
                                      new A(s, p ? T.tokenize(x, p) : x, f, x));
                                  (v = M(a, O, I)),
                                    L && M(a, v, L),
                                    1 < k &&
                                      ((x = { cause: s + ',' + c, reach: y }), e(t, a, r, v.prev, b, x), i) &&
                                      x.reach > i.reach &&
                                      (i.reach = x.reach);
                                }
                              }
                            }
                          }
                      })(e, n, t, n.head, 0),
                      n),
                    i = [],
                    s = o.head.next;
                  s !== o.tail;

                )
                  i.push(s.value), (s = s.next);
                return i;
              },
              hooks: {
                all: {},
                add: function (e, t) {
                  var a = T.hooks.all;
                  (a[e] = a[e] || []), a[e].push(t);
                },
                run: function (e, t) {
                  var a = T.hooks.all[e];
                  if (a && a.length) for (var r, n = 0; (r = a[n++]); ) r(t);
                },
              },
              Token: A,
            }),
            (l.Prism = T),
            (A.stringify = function t(e, a) {
              if ('string' == typeof e) return e;
              var r;
              if (Array.isArray(e))
                return (
                  (r = ''),
                  e.forEach(function (e) {
                    r += t(e, a);
                  }),
                  r
                );
              var n,
                o = {
                  type: e.type,
                  content: t(e.content, a),
                  tag: 'span',
                  classes: ['token', e.type],
                  attributes: {},
                  language: a,
                },
                e = e.alias,
                i =
                  (e && (Array.isArray(e) ? Array.prototype.push.apply(o.classes, e) : o.classes.push(e)),
                  T.hooks.run('wrap', o),
                  '');
              for (n in o.attributes) i += ' ' + n + '="' + (o.attributes[n] || '').replace(/"/g, '&quot;') + '"';
              return '<' + o.tag + ' class="' + o.classes.join(' ') + '"' + i + '>' + o.content + '</' + o.tag + '>';
            }),
            l.document
              ? ((n = T.util.currentScript()) &&
                  ((T.filename = n.src), n.hasAttribute('data-manual')) &&
                  (T.manual = !0),
                T.manual ||
                  ('loading' === (o = document.readyState) || ('interactive' === o && n && n.defer)
                    ? document.addEventListener('DOMContentLoaded', i)
                    : window.requestAnimationFrame
                      ? window.requestAnimationFrame(i)
                      : window.setTimeout(i, 16)))
              : l.addEventListener &&
                !T.disableWorkerMessageHandler &&
                l.addEventListener(
                  'message',
                  function (e) {
                    var e = JSON.parse(e.data),
                      t = e.language,
                      a = e.code,
                      e = e.immediateClose;
                    l.postMessage(T.highlight(a, T.languages[t], t)), e && l.close();
                  },
                  !1,
                ),
            T);
        function A(e, t, a, r) {
          (this.type = e), (this.content = t), (this.alias = a), (this.length = 0 | (r || '').length);
        }
        function P(e, t, a, r) {
          e.lastIndex = t;
          t = e.exec(a);
          return t && r && t[1] && ((e = t[1].length), (t.index += e), (t[0] = t[0].slice(e))), t;
        }
        function c() {
          var e = { value: null, prev: null, next: null },
            t = { value: null, prev: e, next: null };
          (e.next = t), (this.head = e), (this.tail = t), (this.length = 0);
        }
        function M(e, t, a) {
          var r = t.next,
            a = { value: a, prev: t, next: r };
          return (t.next = a), (r.prev = a), e.length++, a;
        }
        function _(e, t, a) {
          for (var r = t.next, n = 0; n < a && r !== e.tail; n++) r = r.next;
          ((t.next = r).prev = t), (e.length -= n);
        }
        function i() {
          T.manual || T.highlightAll();
        }
        void 0 !== t && t.exports && (t.exports = o), 'undefined' != typeof global && (global.Prism = o);
      },
    }),
    Re = e({
      'node_modules/.pnpm/classnames@2.3.2/node_modules/classnames/index.js'(e, t) {
        !(function () {
          'use strict';
          var i = {}.hasOwnProperty;
          function s() {
            for (var e = [], t = 0; t < arguments.length; t++) {
              var a = arguments[t];
              if (a) {
                var r,
                  n = typeof a;
                if ('string' == n || 'number' == n) e.push(a);
                else if (Array.isArray(a)) a.length && (r = s.apply(null, a)) && e.push(r);
                else if ('object' == n)
                  if (a.toString === Object.prototype.toString || a.toString.toString().includes('[native code]'))
                    for (var o in a) i.call(a, o) && a[o] && e.push(o);
                  else e.push(a.toString());
              }
            }
            return e.join(' ');
          }
          void 0 !== t && t.exports
            ? (t.exports = s.default = s)
            : 'function' == typeof define && 'object' == typeof define.amd && define.amd
              ? define('classnames', [], function () {
                  return s;
                })
              : (window.classNames = s);
        })();
      },
    }),
    e = e({
      'node_modules/.pnpm/react-dropdown@1.11.0_react-dom@18.2.0_react@18.2.0/node_modules/react-dropdown/dist/index.js'(
        e,
      ) {
        'use strict';
        Object.defineProperty(e, '__esModule', { value: !0 }), (e.default = void 0);
        var d = (function (e) {
            if (e && e.__esModule) return e;
            if (null === e || ('object' !== s(e) && 'function' != typeof e)) return { default: e };
            var t = i();
            if (t && t.has(e)) return t.get(e);
            var a,
              r = {},
              n = Object.defineProperty && Object.getOwnPropertyDescriptor;
            for (a in e) {
              var o;
              Object.prototype.hasOwnProperty.call(e, a) &&
                ((o = n ? Object.getOwnPropertyDescriptor(e, a) : null) && (o.get || o.set)
                  ? Object.defineProperty(r, a, o)
                  : (r[a] = e[a]));
            }
            (r.default = e), t && t.set(e, r);
            return r;
          })(b()),
          p = (t = Re()) && t.__esModule ? t : { default: t };
        function i() {
          var e;
          return 'function' != typeof WeakMap
            ? null
            : ((i = function () {
                return e;
              }),
              (e = new WeakMap()));
        }
        function s(e) {
          return (s =
            'function' == typeof Symbol && 'symbol' == typeof Symbol.iterator
              ? function (e) {
                  return typeof e;
                }
              : function (e) {
                  return e && 'function' == typeof Symbol && e.constructor === Symbol && e !== Symbol.prototype
                    ? 'symbol'
                    : typeof e;
                })(e);
        }
        function l() {
          return (l =
            Object.assign ||
            function (e) {
              for (var t = 1; t < arguments.length; t++) {
                var a,
                  r = arguments[t];
                for (a in r) Object.prototype.hasOwnProperty.call(r, a) && (e[a] = r[a]);
              }
              return e;
            }).apply(this, arguments);
        }
        function c(t, e) {
          var a,
            r = Object.keys(t);
          return (
            Object.getOwnPropertySymbols &&
              ((a = Object.getOwnPropertySymbols(t)),
              e &&
                (a = a.filter(function (e) {
                  return Object.getOwnPropertyDescriptor(t, e).enumerable;
                })),
              r.push.apply(r, a)),
            r
          );
        }
        function h(e, t, a) {
          return (
            t in e
              ? Object.defineProperty(e, t, { value: a, enumerable: !0, configurable: !0, writable: !0 })
              : (e[t] = a),
            e
          );
        }
        function n(e, t) {
          for (var a = 0; a < t.length; a++) {
            var r = t[a];
            (r.enumerable = r.enumerable || !1),
              (r.configurable = !0),
              'value' in r && (r.writable = !0),
              Object.defineProperty(e, r.key, r);
          }
        }
        function o(e) {
          return (o = Object.setPrototypeOf
            ? Object.getPrototypeOf
            : function (e) {
                return e.__proto__ || Object.getPrototypeOf(e);
              })(e);
        }
        function u(e) {
          if (void 0 === e) throw new ReferenceError("this hasn't been initialised - super() hasn't been called");
          return e;
        }
        function m(e, t) {
          return (m =
            Object.setPrototypeOf ||
            function (e, t) {
              return (e.__proto__ = t), e;
            })(e, t);
        }
        var f = 'Select...',
          t = (function (e) {
            var t,
              a = r;
            if ('function' != typeof e && null !== e)
              throw new TypeError('Super expression must either be null or a function');
            function r(e) {
              var t, a;
              if (this instanceof r)
                return (
                  (t = this),
                  ((t = !(a = o(r).call(this, e)) || ('object' !== s(a) && 'function' != typeof a) ? u(t) : a).state = {
                    selected: t.parseValue(e.value, e.options) || {
                      label: void 0 === e.placeholder ? f : e.placeholder,
                      value: '',
                    },
                    isOpen: !1,
                  }),
                  (t.dropdownRef = (0, d.createRef)()),
                  (t.mounted = !0),
                  (t.handleDocumentClick = t.handleDocumentClick.bind(u(t))),
                  (t.fireChangeEvent = t.fireChangeEvent.bind(u(t))),
                  t
                );
              throw new TypeError('Cannot call a class as a function');
            }
            return (
              (a.prototype = Object.create(e && e.prototype, {
                constructor: { value: a, writable: !0, configurable: !0 },
              })),
              e && m(a, e),
              (a = r),
              (e = [
                {
                  key: 'componentDidUpdate',
                  value: function (e) {
                    this.props.value !== e.value &&
                      (this.props.value
                        ? (e = this.parseValue(this.props.value, this.props.options)) !== this.state.selected &&
                          this.setState({ selected: e })
                        : this.setState({
                            selected: {
                              label: void 0 === this.props.placeholder ? f : this.props.placeholder,
                              value: '',
                            },
                          }));
                  },
                },
                {
                  key: 'componentDidMount',
                  value: function () {
                    document.addEventListener('click', this.handleDocumentClick, !1),
                      document.addEventListener('touchend', this.handleDocumentClick, !1);
                  },
                },
                {
                  key: 'componentWillUnmount',
                  value: function () {
                    (this.mounted = !1),
                      document.removeEventListener('click', this.handleDocumentClick, !1),
                      document.removeEventListener('touchend', this.handleDocumentClick, !1);
                  },
                },
                {
                  key: 'handleMouseDown',
                  value: function (e) {
                    this.props.onFocus &&
                      'function' == typeof this.props.onFocus &&
                      this.props.onFocus(this.state.isOpen),
                      ('mousedown' === e.type && 0 !== e.button) ||
                        (e.stopPropagation(), e.preventDefault(), this.props.disabled) ||
                        this.setState({ isOpen: !this.state.isOpen });
                  },
                },
                {
                  key: 'parseValue',
                  value: function (t, e) {
                    var a;
                    if ('string' == typeof t)
                      for (var r, n = 0, o = e.length; n < o; n++)
                        'group' === e[n].type
                          ? (r = e[n].items.filter(function (e) {
                              return e.value === t;
                            })).length && (a = r[0])
                          : void 0 !== e[n].value && e[n].value === t && (a = e[n]);
                    return a || t;
                  },
                },
                {
                  key: 'setValue',
                  value: function (e, t) {
                    e = { selected: { value: e, label: t }, isOpen: !1 };
                    this.fireChangeEvent(e), this.setState(e);
                  },
                },
                {
                  key: 'fireChangeEvent',
                  value: function (e) {
                    e.selected !== this.state.selected && this.props.onChange && this.props.onChange(e.selected);
                  },
                },
                {
                  key: 'renderOption',
                  value: function (a) {
                    var e = a.value,
                      t = (void 0 === e && (e = a.label || a), a.label || a.value || a),
                      r = e === this.state.selected.value || e === this.state.selected;
                    h((n = {}), ''.concat(this.props.baseClassName, '-option'), !0),
                      h(n, a.className, !!a.className),
                      h(n, 'is-selected', r);
                    var n = (0, p.default)(n),
                      o = Object.keys(a.data || {}).reduce(function (e, t) {
                        return (function (t) {
                          for (var e = 1; e < arguments.length; e++) {
                            var a = null != arguments[e] ? arguments[e] : {};
                            e % 2
                              ? c(a, !0).forEach(function (e) {
                                  h(t, e, a[e]);
                                })
                              : Object.getOwnPropertyDescriptors
                                ? Object.defineProperties(t, Object.getOwnPropertyDescriptors(a))
                                : c(a).forEach(function (e) {
                                    Object.defineProperty(t, e, Object.getOwnPropertyDescriptor(a, e));
                                  });
                          }
                          return t;
                        })({}, e, h({}, 'data-'.concat(t), a.data[t]));
                      }, {});
                    return d.default.createElement(
                      'div',
                      l(
                        {
                          key: e,
                          className: n,
                          onMouseDown: this.setValue.bind(this, e, t),
                          onClick: this.setValue.bind(this, e, t),
                          role: 'option',
                          'aria-selected': r ? 'true' : 'false',
                        },
                        o,
                      ),
                      t,
                    );
                  },
                },
                {
                  key: 'buildMenu',
                  value: function () {
                    var r = this,
                      e = this.props,
                      t = e.options,
                      n = e.baseClassName,
                      e = t.map(function (e) {
                        var t, a;
                        return 'group' === e.type
                          ? ((t = d.default.createElement('div', { className: ''.concat(n, '-title') }, e.name)),
                            (a = e.items.map(function (e) {
                              return r.renderOption(e);
                            })),
                            d.default.createElement(
                              'div',
                              { className: ''.concat(n, '-group'), key: e.name, role: 'listbox', tabIndex: '-1' },
                              t,
                              a,
                            ))
                          : r.renderOption(e);
                      });
                    return e.length
                      ? e
                      : d.default.createElement('div', { className: ''.concat(n, '-noresults') }, 'No options found');
                  },
                },
                {
                  key: 'handleDocumentClick',
                  value: function (e) {
                    !this.mounted ||
                      this.dropdownRef.current.contains(e.target) ||
                      (this.state.isOpen && this.setState({ isOpen: !1 }));
                  },
                },
                {
                  key: 'isValueSelected',
                  value: function () {
                    return 'string' == typeof this.state.selected || '' !== this.state.selected.value;
                  },
                },
                {
                  key: 'render',
                  value: function () {
                    var e = this.props,
                      t = e.baseClassName,
                      a = e.controlClassName,
                      r = e.placeholderClassName,
                      n = e.menuClassName,
                      o = e.arrowClassName,
                      i = e.arrowClosed,
                      s = e.arrowOpen,
                      e = e.className,
                      l = this.props.disabled ? 'Dropdown-disabled' : '',
                      c = 'string' == typeof this.state.selected ? this.state.selected : this.state.selected.label,
                      e = (0, p.default)(
                        (h((u = {}), ''.concat(t, '-root'), !0), h(u, e, !!e), h(u, 'is-open', this.state.isOpen), u),
                      ),
                      a = (0, p.default)((h((u = {}), ''.concat(t, '-control'), !0), h(u, a, !!a), h(u, l, !!l), u)),
                      u = (0, p.default)(
                        (h((l = {}), ''.concat(t, '-placeholder'), !0),
                        h(l, r, !!r),
                        h(l, 'is-selected', this.isValueSelected()),
                        l),
                      ),
                      l = (0, p.default)((h((r = {}), ''.concat(t, '-menu'), !0), h(r, n, !!n), r)),
                      r = (0, p.default)((h((n = {}), ''.concat(t, '-arrow'), !0), h(n, o, !!o), n)),
                      o = d.default.createElement('div', { className: u }, c),
                      n = this.state.isOpen
                        ? d.default.createElement('div', { className: l, 'aria-expanded': 'true' }, this.buildMenu())
                        : null;
                    return d.default.createElement(
                      'div',
                      { ref: this.dropdownRef, className: e },
                      d.default.createElement(
                        'div',
                        {
                          className: a,
                          onMouseDown: this.handleMouseDown.bind(this),
                          onTouchEnd: this.handleMouseDown.bind(this),
                          'aria-haspopup': 'listbox',
                        },
                        o,
                        d.default.createElement(
                          'div',
                          { className: ''.concat(t, '-arrow-wrapper') },
                          s && i ? (this.state.isOpen ? s : i) : d.default.createElement('span', { className: r }),
                        ),
                      ),
                      n,
                    );
                  },
                },
              ]) && n(a.prototype, e),
              t && n(a, t),
              r
            );
          })(d.Component);
        (t.defaultProps = { baseClassName: 'Dropdown' }), (e.default = t);
      },
    }),
    je = {},
    De = je,
    $e = {
      default: () =>
        function () {
          return Yr.default.createElement(Xr, null);
        },
    };
  for (A in $e) M(De, A, { get: $e[A], enumerable: !0 });
  var ze = t(b()),
    Ue = {
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
    },
    Be = class {
      constructor(e) {
        this.init(e, 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : {});
      }
      init(e) {
        var t = 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : {};
        (this.prefix = t.prefix || 'i18next:'), (this.logger = e || Ue), (this.options = t), (this.debug = t.debug);
      }
      log() {
        for (var e = arguments.length, t = new Array(e), a = 0; a < e; a++) t[a] = arguments[a];
        return this.forward(t, 'log', '', !0);
      }
      warn() {
        for (var e = arguments.length, t = new Array(e), a = 0; a < e; a++) t[a] = arguments[a];
        return this.forward(t, 'warn', '', !0);
      }
      error() {
        for (var e = arguments.length, t = new Array(e), a = 0; a < e; a++) t[a] = arguments[a];
        return this.forward(t, 'error', '');
      }
      deprecate() {
        for (var e = arguments.length, t = new Array(e), a = 0; a < e; a++) t[a] = arguments[a];
        return this.forward(t, 'warn', 'WARNING DEPRECATED: ', !0);
      }
      forward(e, t, a, r) {
        return r && !this.debug
          ? null
          : ('string' == typeof e[0] && (e[0] = '' + a + this.prefix + ' ' + e[0]), this.logger[t](e));
      }
      create(e) {
        return new Be(this.logger, { prefix: this.prefix + `:${e}:`, ...this.options });
      }
      clone(e) {
        return ((e = e || this.options).prefix = e.prefix || this.prefix), new Be(this.logger, e);
      }
    },
    l = new Be(),
    r = class {
      constructor() {
        this.observers = {};
      }
      on(e, a) {
        return (
          e.split(' ').forEach((e) => {
            this.observers[e] || (this.observers[e] = new Map());
            var t = this.observers[e].get(a) || 0;
            this.observers[e].set(a, t + 1);
          }),
          this
        );
      }
      off(e, t) {
        this.observers[e] && (t ? this.observers[e].delete(t) : delete this.observers[e]);
      }
      emit(r) {
        for (var e = arguments.length, n = new Array(1 < e ? e - 1 : 0), t = 1; t < e; t++) n[t - 1] = arguments[t];
        this.observers[r] &&
          Array.from(this.observers[r].entries()).forEach((e) => {
            var [t, a] = e;
            for (let e = 0; e < a; e++) t(...n);
          }),
          this.observers['*'] &&
            Array.from(this.observers['*'].entries()).forEach((e) => {
              var [t, a] = e;
              for (let e = 0; e < a; e++) t.apply(t, [r, ...n]);
            });
      }
    };
  function Fe() {
    let a, r;
    var e = new Promise((e, t) => {
      (a = e), (r = t);
    });
    return (e.resolve = a), (e.reject = r), e;
  }
  function Ve(e) {
    return null == e ? '' : '' + e;
  }
  function He(e, t, a) {
    e.forEach((e) => {
      t[e] && (a[e] = t[e]);
    });
  }
  var qe = /###/g;
  function Ge(e, t, a) {
    function r(e) {
      return e && -1 < e.indexOf('###') ? e.replace(qe, '.') : e;
    }
    function n() {
      return !e || 'string' == typeof e;
    }
    var o = 'string' != typeof t ? t : t.split('.');
    let i = 0;
    for (; i < o.length - 1; ) {
      if (n()) return {};
      var s = r(o[i]);
      !e[s] && a && (e[s] = new a()), (e = Object.prototype.hasOwnProperty.call(e, s) ? e[s] : {}), ++i;
    }
    return n() ? {} : { obj: e, k: r(o[i]) };
  }
  function Ke(r, n, o) {
    var { obj: e, k: t } = Ge(r, n, Object);
    if (void 0 !== e || 1 === n.length) e[t] = o;
    else {
      let e = n[n.length - 1],
        t = n.slice(0, n.length - 1),
        a = Ge(r, t, Object);
      for (; void 0 === a.obj && t.length; )
        (e = t[t.length - 1] + '.' + e),
          (t = t.slice(0, t.length - 1)),
          (a = Ge(r, t, Object)) && a.obj && void 0 !== a.obj[a.k + '.' + e] && (a.obj = void 0);
      a.obj[a.k + '.' + e] = o;
    }
  }
  function Je(e, t, a, r) {
    var { obj: e, k: t } = Ge(e, t, Object);
    (e[t] = e[t] || []), r && (e[t] = e[t].concat(a)), r || e[t].push(a);
  }
  function We(e, t) {
    var { obj: e, k: t } = Ge(e, t);
    if (e) return e[t];
  }
  function Ze(e, t, a) {
    for (const r in t)
      '__proto__' !== r &&
        'constructor' !== r &&
        (r in e
          ? 'string' == typeof e[r] || e[r] instanceof String || 'string' == typeof t[r] || t[r] instanceof String
            ? a && (e[r] = t[r])
            : Ze(e[r], t[r], a)
          : (e[r] = t[r]));
  }
  function n(e) {
    return e.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, '\\$&');
  }
  var Xe = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;', '/': '&#x2F;' };
  function Ye(e) {
    return 'string' == typeof e ? e.replace(/[&<>"'\/]/g, (e) => Xe[e]) : e;
  }
  var Qe = [' ', ',', '?', '!', ';'],
    et = new (class {
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
    })(20);
  function tt(e, t, a) {
    (t = t || ''), (a = a || '');
    var r = Qe.filter((e) => t.indexOf(e) < 0 && a.indexOf(e) < 0);
    if (0 === r.length) return 1;
    var n,
      r = et.getRegExp(`(${r.map((e) => ('?' === e ? '\\?' : e)).join('|')})`);
    let o = !r.test(e);
    return o || (0 < (n = e.indexOf(a)) && !r.test(e.substring(0, n)) && (o = !0)), o;
  }
  function at(e, t, a) {
    var o = 2 < arguments.length && void 0 !== a ? a : '.';
    if (e) {
      if (e[t]) return e[t];
      var i = t.split(o);
      let n = e;
      for (let r = 0; r < i.length; ) {
        if (!n || 'object' != typeof n) return;
        let t,
          a = '';
        for (let e = r; e < i.length; ++e)
          if (
            (e !== r && (a += o),
            (a += i[e]),
            void 0 !== (t = n[a]) && !(-1 < ['string', 'number', 'boolean'].indexOf(typeof t) && e < i.length - 1))
          ) {
            r += e - r + 1;
            break;
          }
        n = t;
      }
      return n;
    }
  }
  function rt(e) {
    return e && 0 < e.indexOf('_') ? e.replace('_', '-') : e;
  }
  var nt = class extends r {
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
      getResource(e, t, a) {
        var r = 3 < arguments.length && void 0 !== arguments[3] ? arguments[3] : {},
          n = (void 0 !== r.keySeparator ? r : this.options).keySeparator,
          r = (void 0 !== r.ignoreJSONStructure ? r : this.options).ignoreJSONStructure;
        let o;
        -1 < e.indexOf('.')
          ? (o = e.split('.'))
          : ((o = [e, t]),
            a && (Array.isArray(a) ? o.push(...a) : 'string' == typeof a && n ? o.push(...a.split(n)) : o.push(a)));
        var i = We(this.data, o);
        return (
          !i && !t && !a && -1 < e.indexOf('.') && ((e = o[0]), (t = o[1]), (a = o.slice(2).join('.'))),
          i || !r || 'string' != typeof a ? i : at(this.data && this.data[e] && this.data[e][t], a, n)
        );
      }
      addResource(e, t, a, r) {
        var n = 4 < arguments.length && void 0 !== arguments[4] ? arguments[4] : { silent: !1 },
          o = (void 0 !== n.keySeparator ? n : this.options).keySeparator;
        let i = [e, t];
        a && (i = i.concat(o ? a.split(o) : a)),
          -1 < e.indexOf('.') && ((r = t), (t = (i = e.split('.'))[1])),
          this.addNamespaces(t),
          Ke(this.data, i, r),
          n.silent || this.emit('added', e, t, a, r);
      }
      addResources(e, t, a) {
        var r = 3 < arguments.length && void 0 !== arguments[3] ? arguments[3] : { silent: !1 };
        for (const n in a)
          ('string' != typeof a[n] && '[object Array]' !== Object.prototype.toString.apply(a[n])) ||
            this.addResource(e, t, n, a[n], { silent: !0 });
        r.silent || this.emit('added', e, t, a);
      }
      addResourceBundle(e, t, a, r, n) {
        var o = 5 < arguments.length && void 0 !== arguments[5] ? arguments[5] : { silent: !1, skipCopy: !1 };
        let i = [e, t],
          s =
            (-1 < e.indexOf('.') && ((r = a), (a = t), (t = (i = e.split('.'))[1])),
            this.addNamespaces(t),
            We(this.data, i) || {});
        o.skipCopy || (a = JSON.parse(JSON.stringify(a))),
          r ? Ze(s, a, n) : (s = { ...s, ...a }),
          Ke(this.data, i, s),
          o.silent || this.emit('added', e, t, a);
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
    },
    ot = {
      processors: {},
      addPostProcessor(e) {
        this.processors[e.name] = e;
      },
      handle(e, t, a, r, n) {
        return (
          e.forEach((e) => {
            this.processors[e] && (t = this.processors[e].process(t, a, r, n));
          }),
          t
        );
      },
    },
    it = {},
    st = class extends r {
      constructor(e) {
        var t = 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : {};
        super(),
          He(
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
          (this.logger = l.create('translator'));
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
        let a = (void 0 !== t.nsSeparator ? t : this.options).nsSeparator;
        void 0 === a && (a = ':');
        var r = (void 0 !== t.keySeparator ? t : this.options).keySeparator;
        let n = t.ns || this.options.defaultNS || [];
        var o = a && -1 < e.indexOf(a),
          t = !(
            this.options.userDefinedKeySeparator ||
            t.keySeparator ||
            this.options.userDefinedNsSeparator ||
            t.nsSeparator ||
            tt(e, a, r)
          );
        if (o && !t) {
          o = e.match(this.interpolator.nestingRegexp);
          if (o && 0 < o.length) return { key: e, namespaces: n };
          t = e.split(a);
          (a !== r || (a === r && -1 < this.options.ns.indexOf(t[0]))) && (n = t.shift()), (e = t.join(r));
        }
        return { key: e, namespaces: (n = 'string' == typeof n ? [n] : n) };
      }
      translate(a, r, n) {
        if (
          ((r =
            (r =
              'object' ==
              typeof (r =
                'object' != typeof r && this.options.overloadTranslationOptionHandler
                  ? this.options.overloadTranslationOptionHandler(arguments)
                  : r)
                ? { ...r }
                : r) || {}),
          null == a)
        )
          return '';
        Array.isArray(a) || (a = [String(a)]);
        var e = (void 0 !== r.returnDetails ? r : this.options).returnDetails,
          o = (void 0 !== r.keySeparator ? r : this.options).keySeparator;
        const { key: i, namespaces: t } = this.extractFromKey(a[a.length - 1], r),
          s = t[t.length - 1];
        var l = r.lng || this.language,
          c = r.appendNamespaceToCIMode || this.options.appendNamespaceToCIMode;
        if (l && 'cimode' === l.toLowerCase())
          return c
            ? ((c = r.nsSeparator || this.options.nsSeparator),
              e
                ? {
                    res: '' + s + c + i,
                    usedKey: i,
                    exactUsedKey: i,
                    usedLng: l,
                    usedNS: s,
                    usedParams: this.getUsedParamsDetails(r),
                  }
                : '' + s + c + i)
            : e
              ? { res: i, usedKey: i, exactUsedKey: i, usedLng: l, usedNS: s, usedParams: this.getUsedParamsDetails(r) }
              : i;
        c = this.resolve(a, r);
        let u = c && c.res;
        var d = (c && c.usedKey) || i,
          p = (c && c.exactUsedKey) || i,
          h = Object.prototype.toString.apply(u),
          m = (void 0 !== r.joinArrays ? r : this.options).joinArrays,
          f = !this.i18nFormat || this.i18nFormat.handleAsObject,
          g = 'string' != typeof u && 'boolean' != typeof u && 'number' != typeof u;
        if (
          f &&
          u &&
          g &&
          ['[object Number]', '[object Function]', '[object RegExp]'].indexOf(h) < 0 &&
          ('string' != typeof m || '[object Array]' !== h)
        ) {
          if (!r.returnObjects && !this.options.returnObjects)
            return (
              this.options.returnedObjectHandler ||
                this.logger.warn('accessing an object - but returnObjects options is not enabled!'),
              (g = this.options.returnedObjectHandler
                ? this.options.returnedObjectHandler(d, u, { ...r, ns: t })
                : `key '${i} (${this.language})' returned an object instead of string.`),
              e ? ((c.res = g), (c.usedParams = this.getUsedParamsDetails(r)), c) : g
            );
          if (o) {
            var v,
              g = '[object Array]' === h,
              b = g ? [] : {},
              y = g ? p : d;
            for (const k in u)
              Object.prototype.hasOwnProperty.call(u, k) &&
                ((v = '' + y + o + k), (b[k] = this.translate(v, { ...r, joinArrays: !1, ns: t })), b[k] === v) &&
                (b[k] = u[k]);
            u = b;
          }
        } else if (f && 'string' == typeof m && '[object Array]' === h)
          u = (u = u.join(m)) && this.extendTranslation(u, a, r, n);
        else {
          let e = !1,
            t = !1;
          g = void 0 !== r.count && 'string' != typeof r.count;
          const w = st.hasDefaultValue(r);
          (p = g ? this.pluralResolver.getSuffix(l, r.count, r) : ''),
            (d = r.ordinal && g ? this.pluralResolver.getSuffix(l, r.count, { ordinal: !1 }) : '');
          const E = g && !r.ordinal && 0 === r.count && this.pluralResolver.shouldUseIntlApi(),
            C =
              (E && r[`defaultValue${this.options.pluralSeparator}zero`]) ||
              r['defaultValue' + p] ||
              r['defaultValue' + d] ||
              r.defaultValue,
            N =
              (!this.isValidLookup(u) && w && ((e = !0), (u = C)),
              this.isValidLookup(u) || ((t = !0), (u = i)),
              (r.missingKeyNoValueFallbackToKey || this.options.missingKeyNoValueFallbackToKey) && t ? void 0 : u),
            x = w && C !== u && this.options.updateMissing;
          if (t || e || x) {
            this.logger.log(x ? 'updateKey' : 'missingKey', l, s, i, x ? C : u),
              o &&
                (f = this.resolve(i, { ...r, keySeparator: !1 })) &&
                f.res &&
                this.logger.warn(
                  'Seems the loaded translations were in flat JSON format instead of nested. Either set keySeparator: false on init or make sure your translations are published in nested format.',
                );
            let t = [];
            var S = this.languageUtils.getFallbackCodes(this.options.fallbackLng, r.lng || this.language);
            if ('fallback' === this.options.saveMissingTo && S && S[0]) for (let e = 0; e < S.length; e++) t.push(S[e]);
            else
              'all' === this.options.saveMissingTo
                ? (t = this.languageUtils.toResolveHierarchy(r.lng || this.language))
                : t.push(r.lng || this.language);
            const I = (e, t, a) => {
              a = w && a !== u ? a : N;
              this.options.missingKeyHandler
                ? this.options.missingKeyHandler(e, s, t, a, x, r)
                : this.backendConnector &&
                  this.backendConnector.saveMissing &&
                  this.backendConnector.saveMissing(e, s, t, a, x, r),
                this.emit('missingKey', e, s, t, u);
            };
            this.options.saveMissing &&
              (this.options.saveMissingPlurals && g
                ? t.forEach((t) => {
                    var e = this.pluralResolver.getSuffixes(t, r);
                    E &&
                      r[`defaultValue${this.options.pluralSeparator}zero`] &&
                      e.indexOf(this.options.pluralSeparator + 'zero') < 0 &&
                      e.push(this.options.pluralSeparator + 'zero'),
                      e.forEach((e) => {
                        I([t], i + e, r['defaultValue' + e] || C);
                      });
                  })
                : I(t, i, C));
          }
          (u = this.extendTranslation(u, a, r, c, n)),
            t && u === i && this.options.appendNamespaceToMissingKey && (u = s + ':' + i),
            (t || e) &&
              this.options.parseMissingKeyHandler &&
              (u =
                'v1' !== this.options.compatibilityAPI
                  ? this.options.parseMissingKeyHandler(
                      this.options.appendNamespaceToMissingKey ? s + ':' + i : i,
                      e ? u : void 0,
                    )
                  : this.options.parseMissingKeyHandler(u));
        }
        return e ? ((c.res = u), (c.usedParams = this.getUsedParamsDetails(r)), c) : u;
      }
      extendTranslation(a, r, n, o, i) {
        var s = this;
        if (this.i18nFormat && this.i18nFormat.parse)
          a = this.i18nFormat.parse(
            a,
            { ...this.options.interpolation.defaultVariables, ...n },
            n.lng || this.language || o.usedLng,
            o.usedNS,
            o.usedKey,
            { resolved: o },
          );
        else if (!n.skipInterpolation) {
          n.interpolation &&
            this.interpolator.init({ ...n, interpolation: { ...this.options.interpolation, ...n.interpolation } });
          var l =
            'string' == typeof a &&
            (n && n.interpolation && void 0 !== n.interpolation.skipOnVariables ? n : this.options).interpolation
              .skipOnVariables;
          let e,
            t =
              (l && ((c = a.match(this.interpolator.nestingRegexp)), (e = c && c.length)),
              n.replace && 'string' != typeof n.replace ? n.replace : n);
          this.options.interpolation.defaultVariables && (t = { ...this.options.interpolation.defaultVariables, ...t }),
            (a = this.interpolator.interpolate(a, t, n.lng || this.language, n)),
            l && ((l = (c = a.match(this.interpolator.nestingRegexp)) && c.length), e < l) && (n.nest = !1),
            !n.lng && 'v1' !== this.options.compatibilityAPI && o && o.res && (n.lng = o.usedLng),
            !1 !== n.nest &&
              (a = this.interpolator.nest(
                a,
                function () {
                  for (var e = arguments.length, t = new Array(e), a = 0; a < e; a++) t[a] = arguments[a];
                  return i && i[0] === t[0] && !n.context
                    ? (s.logger.warn(`It seems you are nesting recursively key: ${t[0]} in key: ` + r[0]), null)
                    : s.translate(...t, r);
                },
                n,
              )),
            n.interpolation && this.interpolator.reset();
        }
        var c = n.postProcess || this.options.postProcess,
          l = 'string' == typeof c ? [c] : c;
        return (a =
          null != a && l && l.length && !1 !== n.applyPostProcessor
            ? ot.handle(
                l,
                a,
                r,
                this.options && this.options.postProcessPassResolved
                  ? { i18nResolved: { ...o, usedParams: this.getUsedParamsDetails(n) }, ...n }
                  : n,
                this,
              )
            : a);
      }
      resolve(e) {
        let d = 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : {},
          p,
          r,
          h,
          m,
          n;
        return (
          (e = 'string' == typeof e ? [e] : e).forEach((t) => {
            if (!this.isValidLookup(p)) {
              t = this.extractFromKey(t, d);
              const s = t.key;
              r = s;
              let e = t.namespaces;
              this.options.fallbackNS && (e = e.concat(this.options.fallbackNS));
              const l = void 0 !== d.count && 'string' != typeof d.count,
                c = l && !d.ordinal && 0 === d.count && this.pluralResolver.shouldUseIntlApi(),
                u =
                  void 0 !== d.context &&
                  ('string' == typeof d.context || 'number' == typeof d.context) &&
                  '' !== d.context,
                a = d.lngs || this.languageUtils.toResolveHierarchy(d.lng || this.language, d.fallbackLng);
              e.forEach((i) => {
                this.isValidLookup(p) ||
                  ((n = i),
                  !it[a[0] + '-' + i] &&
                    this.utils &&
                    this.utils.hasLoadedNamespace &&
                    !this.utils.hasLoadedNamespace(n) &&
                    ((it[a[0] + '-' + i] = !0),
                    this.logger.warn(
                      `key "${r}" for languages "${a.join(', ')}" won't get resolved as namespace "${n}" was not yet loaded`,
                      'This means something IS WRONG in your setup. You access the t function before i18next.init / i18next.loadNamespace / i18next.changeLanguage was done. Wait for the callback or Promise to resolve before accessing it!!!',
                    )),
                  a.forEach((t) => {
                    if (!this.isValidLookup(p)) {
                      m = t;
                      var e,
                        a = [s];
                      if (this.i18nFormat && this.i18nFormat.addLookupKeys)
                        this.i18nFormat.addLookupKeys(a, s, t, i, d);
                      else {
                        let e;
                        l && (e = this.pluralResolver.getSuffix(t, d.count, d));
                        var r,
                          n = this.options.pluralSeparator + 'zero',
                          o = this.options.pluralSeparator + 'ordinal' + this.options.pluralSeparator;
                        l &&
                          (a.push(s + e),
                          d.ordinal && 0 === e.indexOf(o) && a.push(s + e.replace(o, this.options.pluralSeparator)),
                          c) &&
                          a.push(s + n),
                          u &&
                            ((r = '' + s + this.options.contextSeparator + d.context), a.push(r), l) &&
                            (a.push(r + e),
                            d.ordinal && 0 === e.indexOf(o) && a.push(r + e.replace(o, this.options.pluralSeparator)),
                            c) &&
                            a.push(r + n);
                      }
                      for (; (e = a.pop()); ) this.isValidLookup(p) || ((h = e), (p = this.getResource(t, i, e, d)));
                    }
                  }));
              });
            }
          }),
          { res: p, usedKey: r, exactUsedKey: h, usedLng: m, usedNS: n }
        );
      }
      isValidLookup(e) {
        return !(
          void 0 === e ||
          (!this.options.returnNull && null === e) ||
          (!this.options.returnEmptyString && '' === e)
        );
      }
      getResource(e, t, a) {
        var r = 3 < arguments.length && void 0 !== arguments[3] ? arguments[3] : {};
        return (this.i18nFormat && this.i18nFormat.getResource ? this.i18nFormat : this.resourceStore).getResource(
          e,
          t,
          a,
          r,
        );
      }
      getUsedParamsDetails() {
        var e = 0 < arguments.length && void 0 !== arguments[0] ? arguments[0] : {},
          t = e.replace && 'string' != typeof e.replace;
        let a = t ? e.replace : e;
        if (
          (t && void 0 !== e.count && (a.count = e.count),
          this.options.interpolation.defaultVariables && (a = { ...this.options.interpolation.defaultVariables, ...a }),
          !t)
        ) {
          a = { ...a };
          for (const r of [
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
            delete a[r];
        }
        return a;
      }
      static hasDefaultValue(e) {
        var t = 'defaultValue';
        for (const a in e)
          if (Object.prototype.hasOwnProperty.call(e, a) && t === a.substring(0, t.length) && void 0 !== e[a])
            return !0;
        return !1;
      }
    };
  function lt(e) {
    return e.charAt(0).toUpperCase() + e.slice(1);
  }
  var ct = class {
      constructor(e) {
        (this.options = e),
          (this.supportedLngs = this.options.supportedLngs || !1),
          (this.logger = l.create('languageUtils'));
      }
      getScriptPartFromCode(e) {
        return !(e = rt(e)) ||
          e.indexOf('-') < 0 ||
          2 === (e = e.split('-')).length ||
          (e.pop(), 'x' === e[e.length - 1].toLowerCase())
          ? null
          : this.formatLanguageCode(e.join('-'));
      }
      getLanguagePartFromCode(e) {
        return !(e = rt(e)) || e.indexOf('-') < 0 ? e : ((e = e.split('-')), this.formatLanguageCode(e[0]));
      }
      formatLanguageCode(t) {
        if ('string' == typeof t && -1 < t.indexOf('-')) {
          var a = ['hans', 'hant', 'latn', 'cyrl', 'cans', 'mong', 'arab'];
          let e = t.split('-');
          return (
            this.options.lowerCaseLng
              ? (e = e.map((e) => e.toLowerCase()))
              : 2 === e.length
                ? ((e[0] = e[0].toLowerCase()),
                  (e[1] = e[1].toUpperCase()),
                  -1 < a.indexOf(e[1].toLowerCase()) && (e[1] = lt(e[1].toLowerCase())))
                : 3 === e.length &&
                  ((e[0] = e[0].toLowerCase()),
                  2 === e[1].length && (e[1] = e[1].toUpperCase()),
                  'sgn' !== e[0] && 2 === e[2].length && (e[2] = e[2].toUpperCase()),
                  -1 < a.indexOf(e[1].toLowerCase()) && (e[1] = lt(e[1].toLowerCase())),
                  -1 < a.indexOf(e[2].toLowerCase())) &&
                  (e[2] = lt(e[2].toLowerCase())),
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
        let a;
        return (
          e.forEach((e) => {
            a || ((e = this.formatLanguageCode(e)), this.options.supportedLngs && !this.isSupportedCode(e)) || (a = e);
          }),
          !a &&
            this.options.supportedLngs &&
            e.forEach((e) => {
              if (!a) {
                const t = this.getLanguagePartFromCode(e);
                if (this.isSupportedCode(t)) return (a = t);
                a = this.options.supportedLngs.find((e) =>
                  e === t ||
                  (!(e.indexOf('-') < 0 && t.indexOf('-') < 0) &&
                    ((0 < e.indexOf('-') && t.indexOf('-') < 0 && e.substring(0, e.indexOf('-')) === t) ||
                      (0 === e.indexOf(t) && 1 < t.length)))
                    ? e
                    : void 0,
                );
              }
            }),
          (a = a || this.getFallbackCodes(this.options.fallbackLng)[0])
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
        let a = e[t];
        return (
          (a =
            (a =
              (a = (a = a || e[this.getScriptPartFromCode(t)]) || e[this.formatLanguageCode(t)]) ||
              e[this.getLanguagePartFromCode(t)]) || e.default) || []
        );
      }
      toResolveHierarchy(e, t) {
        t = this.getFallbackCodes(t || this.options.fallbackLng || [], e);
        const a = [],
          r = (e) => {
            e &&
              (this.isSupportedCode(e)
                ? a.push(e)
                : this.logger.warn('rejecting language code not found in supportedLngs: ' + e));
          };
        return (
          'string' == typeof e && (-1 < e.indexOf('-') || -1 < e.indexOf('_'))
            ? ('languageOnly' !== this.options.load && r(this.formatLanguageCode(e)),
              'languageOnly' !== this.options.load &&
                'currentOnly' !== this.options.load &&
                r(this.getScriptPartFromCode(e)),
              'currentOnly' !== this.options.load && r(this.getLanguagePartFromCode(e)))
            : 'string' == typeof e && r(this.formatLanguageCode(e)),
          t.forEach((e) => {
            a.indexOf(e) < 0 && r(this.formatLanguageCode(e));
          }),
          a
        );
      }
    },
    ut = [
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
    ],
    dt = {
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
    },
    pt = ['v1', 'v2', 'v3'],
    ht = ['v4'],
    mt = { zero: 0, one: 1, two: 2, few: 3, many: 4, other: 5 };
  function ft() {
    const a = {};
    return (
      ut.forEach((t) => {
        t.lngs.forEach((e) => {
          a[e] = { numbers: t.nr, plurals: dt[t.fc] };
        });
      }),
      a
    );
  }
  var gt = class {
    constructor(e) {
      var t = 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : {};
      (this.languageUtils = e),
        (this.options = t),
        (this.logger = l.create('pluralResolver')),
        (this.options.compatibilityJSON && !ht.includes(this.options.compatibilityJSON)) ||
          ('undefined' != typeof Intl && Intl.PluralRules) ||
          ((this.options.compatibilityJSON = 'v3'),
          this.logger.error(
            'Your environment seems not to be Intl API compatible, use an Intl.PluralRules polyfill. Will fallback to the compatibilityJSON v3 format handling.',
          )),
        (this.rules = ft());
    }
    addRule(e, t) {
      this.rules[e] = t;
    }
    getRule(e) {
      var t = 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : {};
      if (this.shouldUseIntlApi())
        try {
          return new Intl.PluralRules(rt('dev' === e ? 'en' : e), { type: t.ordinal ? 'ordinal' : 'cardinal' });
        } catch (e) {
          return;
        }
      return this.rules[e] || this.rules[this.languageUtils.getLanguagePartFromCode(e)];
    }
    needsPlural(e) {
      e = this.getRule(e, 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : {});
      return this.shouldUseIntlApi() ? e && 1 < e.resolvedOptions().pluralCategories.length : e && 1 < e.numbers.length;
    }
    getPluralFormsOfKey(e, t) {
      return this.getSuffixes(e, 2 < arguments.length && void 0 !== arguments[2] ? arguments[2] : {}).map(
        (e) => '' + t + e,
      );
    }
    getSuffixes(t) {
      let a = 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : {};
      var e = this.getRule(t, a);
      return e
        ? this.shouldUseIntlApi()
          ? e
              .resolvedOptions()
              .pluralCategories.sort((e, t) => mt[e] - mt[t])
              .map((e) => '' + this.options.prepend + (a.ordinal ? 'ordinal' + this.options.prepend : '') + e)
          : e.numbers.map((e) => this.getSuffix(t, e, a))
        : [];
    }
    getSuffix(e, t) {
      var a = 2 < arguments.length && void 0 !== arguments[2] ? arguments[2] : {},
        r = this.getRule(e, a);
      return r
        ? this.shouldUseIntlApi()
          ? '' + this.options.prepend + (a.ordinal ? 'ordinal' + this.options.prepend : '') + r.select(t)
          : this.getSuffixRetroCompatible(r, t)
        : (this.logger.warn('no plural rule found for: ' + e), '');
    }
    getSuffixRetroCompatible(e, t) {
      t = e.noAbs ? e.plurals(t) : e.plurals(Math.abs(t));
      let a = e.numbers[t];
      this.options.simplifyPluralSuffix &&
        2 === e.numbers.length &&
        1 === e.numbers[0] &&
        (2 === a ? (a = 'plural') : 1 === a && (a = ''));
      var r = () => (this.options.prepend && a.toString() ? this.options.prepend + a.toString() : a.toString());
      return 'v1' === this.options.compatibilityJSON
        ? 1 === a
          ? ''
          : 'number' == typeof a
            ? '_plural_' + a.toString()
            : r()
        : 'v2' === this.options.compatibilityJSON ||
            (this.options.simplifyPluralSuffix && 2 === e.numbers.length && 1 === e.numbers[0])
          ? r()
          : this.options.prepend && t.toString()
            ? this.options.prepend + t.toString()
            : t.toString();
    }
    shouldUseIntlApi() {
      return !pt.includes(this.options.compatibilityJSON);
    }
  };
  function vt(e, t, a, r, n) {
    var o,
      i,
      s,
      l = 3 < arguments.length && void 0 !== r ? r : '.',
      c = !(4 < arguments.length && void 0 !== n) || n;
    i = t;
    let u = void 0 !== (o = We((o = e), (s = a))) ? o : We(i, s);
    return (u = !u && c && 'string' == typeof a && void 0 === (u = at(e, a, l)) ? at(t, a, l) : u);
  }
  var bt = class {
    constructor() {
      var e = 0 < arguments.length && void 0 !== arguments[0] ? arguments[0] : {};
      (this.logger = l.create('interpolator')),
        (this.options = e),
        (this.format = (e.interpolation && e.interpolation.format) || ((e) => e)),
        this.init(e);
    }
    init() {
      var e = 0 < arguments.length && void 0 !== arguments[0] ? arguments[0] : {},
        e = (e.interpolation || (e.interpolation = { escapeValue: !0 }), e.interpolation);
      (this.escape = void 0 !== e.escape ? e.escape : Ye),
        (this.escapeValue = void 0 === e.escapeValue || e.escapeValue),
        (this.useRawValueToEscape = void 0 !== e.useRawValueToEscape && e.useRawValueToEscape),
        (this.prefix = e.prefix ? n(e.prefix) : e.prefixEscaped || '{{'),
        (this.suffix = e.suffix ? n(e.suffix) : e.suffixEscaped || '}}'),
        (this.formatSeparator = e.formatSeparator || e.formatSeparator || ','),
        (this.unescapePrefix = e.unescapeSuffix ? '' : e.unescapePrefix || '-'),
        (this.unescapeSuffix = (!this.unescapePrefix && e.unescapeSuffix) || ''),
        (this.nestingPrefix = e.nestingPrefix ? n(e.nestingPrefix) : e.nestingPrefixEscaped || n('$t(')),
        (this.nestingSuffix = e.nestingSuffix ? n(e.nestingSuffix) : e.nestingSuffixEscaped || n(')')),
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
    interpolate(r, a, n, o) {
      let i, s, l;
      const c = (this.options && this.options.interpolation && this.options.interpolation.defaultVariables) || {};
      function t(e) {
        return e.replace(/\$/g, '$$$$');
      }
      const u = (e) => {
          var t;
          return e.indexOf(this.formatSeparator) < 0
            ? ((t = vt(a, c, e, this.options.keySeparator, this.options.ignoreJSONStructure)),
              this.alwaysFormat ? this.format(t, void 0, n, { ...o, ...a, interpolationkey: e }) : t)
            : ((e = (t = e.split(this.formatSeparator)).shift().trim()),
              (t = t.join(this.formatSeparator).trim()),
              this.format(vt(a, c, e, this.options.keySeparator, this.options.ignoreJSONStructure), t, n, {
                ...o,
                ...a,
                interpolationkey: e,
              }));
        },
        d = (this.resetRegExp(), (o && o.missingInterpolationHandler) || this.options.missingInterpolationHandler),
        p = (o && o.interpolation && void 0 !== o.interpolation.skipOnVariables ? o : this.options).interpolation
          .skipOnVariables;
      return (
        [
          { regex: this.regexpUnescape, safeValue: (e) => t(e) },
          { regex: this.regexp, safeValue: (e) => (this.escapeValue ? t(this.escape(e)) : t(e)) },
        ].forEach((e) => {
          for (l = 0; (i = e.regex.exec(r)); ) {
            var t = i[1].trim();
            if (void 0 === (s = u(t)))
              if ('function' == typeof d) {
                var a = d(r, i, o);
                s = 'string' == typeof a ? a : '';
              } else {
                if (!o || !Object.prototype.hasOwnProperty.call(o, t)) {
                  if (p) {
                    s = i[0];
                    continue;
                  }
                  this.logger.warn(`missed to pass in variable ${t} for interpolating ` + r);
                }
                s = '';
              }
            else 'string' == typeof s || this.useRawValueToEscape || (s = Ve(s));
            a = e.safeValue(s);
            if (
              ((r = r.replace(i[0], a)),
              p ? ((e.regex.lastIndex += s.length), (e.regex.lastIndex -= i[0].length)) : (e.regex.lastIndex = 0),
              ++l >= this.maxReplaces)
            )
              break;
          }
        }),
        r
      );
    }
    nest(a, r) {
      let n = 2 < arguments.length && void 0 !== arguments[2] ? arguments[2] : {},
        o,
        i,
        s;
      function l(a, e) {
        var r = this.nestingOptionsSeparator;
        if (!(a.indexOf(r) < 0)) {
          var n = a.split(new RegExp(r + '[ ]*{'));
          let t = '{' + n[1];
          a = n[0];
          var n = (t = this.interpolate(t, s)).match(/'/g),
            o = t.match(/"/g);
          ((n && n.length % 2 == 0 && !o) || o.length % 2 != 0) && (t = t.replace(/'/g, '"'));
          try {
            (s = JSON.parse(t)), e && (s = { ...e, ...s });
          } catch (e) {
            return this.logger.warn('failed parsing options string in nesting for key ' + a, e), '' + a + r + t;
          }
          s.defaultValue && -1 < s.defaultValue.indexOf(this.prefix) && delete s.defaultValue;
        }
        return a;
      }
      for (; (o = this.nestingRegexp.exec(a)); ) {
        let e = [],
          t =
            (((s = (s = { ...n }).replace && 'string' != typeof s.replace ? s.replace : s).applyPostProcessor = !1),
            delete s.defaultValue,
            !1);
        var c;
        if (
          (-1 === o[0].indexOf(this.formatSeparator) ||
            /{.*}/.test(o[1]) ||
            ((c = o[1].split(this.formatSeparator).map((e) => e.trim())), (o[1] = c.shift()), (e = c), (t = !0)),
          (i = r(l.call(this, o[1].trim(), s), s)) && o[0] === a && 'string' != typeof i)
        )
          return i;
        (i = 'string' != typeof i ? Ve(i) : i) ||
          (this.logger.warn(`missed to resolve ${o[1]} for nesting ` + a), (i = '')),
          t && (i = e.reduce((e, t) => this.format(e, t, n.lng, { ...n, interpolationkey: o[1].trim() }), i.trim())),
          (a = a.replace(o[0], i)),
          (this.regexp.lastIndex = 0);
      }
      return a;
    }
  };
  function yt(e) {
    let t = e.toLowerCase().trim();
    const a = {};
    return (
      -1 < e.indexOf('(') &&
        ((e = e.split('(')),
        (t = e[0].toLowerCase().trim()),
        (e = e[1].substring(0, e[1].length - 1)),
        'currency' === t && e.indexOf(':') < 0
          ? a.currency || (a.currency = e.trim())
          : 'relativetime' === t && e.indexOf(':') < 0
            ? a.range || (a.range = e.trim())
            : e.split(';').forEach((e) => {
                var t;
                e &&
                  (([e, ...t] = e.split(':')),
                  (t = t
                    .join(':')
                    .trim()
                    .replace(/^'+|'+$/g, '')),
                  a[e.trim()] || (a[e.trim()] = t),
                  'false' === t && (a[e.trim()] = !1),
                  'true' === t && (a[e.trim()] = !0),
                  isNaN(t) || (a[e.trim()] = parseInt(t, 10)));
              })),
      { formatName: t, formatOptions: a }
    );
  }
  function o(o) {
    const i = {};
    return function (e, t, a) {
      var r = t + JSON.stringify(a);
      let n = i[r];
      return n || ((n = o(rt(t), a)), (i[r] = n)), n(e);
    };
  }
  var St = class {
    constructor() {
      var e = 0 < arguments.length && void 0 !== arguments[0] ? arguments[0] : {};
      (this.logger = l.create('formatter')),
        (this.options = e),
        (this.formats = {
          number: o((e, t) => {
            const a = new Intl.NumberFormat(e, { ...t });
            return (e) => a.format(e);
          }),
          currency: o((e, t) => {
            const a = new Intl.NumberFormat(e, { ...t, style: 'currency' });
            return (e) => a.format(e);
          }),
          datetime: o((e, t) => {
            const a = new Intl.DateTimeFormat(e, { ...t });
            return (e) => a.format(e);
          }),
          relativetime: o((e, t) => {
            const a = new Intl.RelativeTimeFormat(e, { ...t });
            return (e) => a.format(e, t.range || 'day');
          }),
          list: o((e, t) => {
            const a = new Intl.ListFormat(e, { ...t });
            return (e) => a.format(e);
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
      this.formats[e.toLowerCase().trim()] = o(t);
    }
    format(e, t, i) {
      let s = 3 < arguments.length && void 0 !== arguments[3] ? arguments[3] : {};
      return t.split(this.formatSeparator).reduce((t, a) => {
        var { formatName: a, formatOptions: r } = yt(a);
        if (this.formats[a]) {
          let e = t;
          try {
            var n = (s && s.formatParams && s.formatParams[s.interpolationkey]) || {},
              o = n.locale || n.lng || s.locale || s.lng || i;
            e = this.formats[a](t, o, { ...r, ...s, ...n });
          } catch (e) {
            this.logger.warn(e);
          }
          return e;
        }
        return this.logger.warn('there was no format function for ' + a), t;
      }, e);
    }
  };
  function kt(e, t) {
    void 0 !== e.pending[t] && (delete e.pending[t], e.pendingCount--);
  }
  var wt = class extends r {
    constructor(e, t, a) {
      var r = 3 < arguments.length && void 0 !== arguments[3] ? arguments[3] : {};
      super(),
        (this.backend = e),
        (this.store = t),
        (this.services = a),
        (this.languageUtils = a.languageUtils),
        (this.options = r),
        (this.logger = l.create('backendConnector')),
        (this.waitingReads = []),
        (this.maxParallelReads = r.maxParallelReads || 10),
        (this.readingCalls = 0),
        (this.maxRetries = 0 <= r.maxRetries ? r.maxRetries : 5),
        (this.retryTimeout = 1 <= r.retryTimeout ? r.retryTimeout : 350),
        (this.state = {}),
        (this.queue = []),
        this.backend && this.backend.init && this.backend.init(a, r.backend, r);
    }
    queueLoad(e, t, n, a) {
      const o = {},
        i = {},
        s = {},
        l = {};
      return (
        e.forEach((a) => {
          let r = !0;
          t.forEach((e) => {
            var t = a + '|' + e;
            !n.reload && this.store.hasResourceBundle(a, e)
              ? (this.state[t] = 2)
              : this.state[t] < 0 ||
                (1 === this.state[t]
                  ? void 0 === i[t] && (i[t] = !0)
                  : ((this.state[t] = 1),
                    (r = !1),
                    void 0 === i[t] && (i[t] = !0),
                    void 0 === o[t] && (o[t] = !0),
                    void 0 === l[e] && (l[e] = !0)));
          }),
            r || (s[a] = !0);
        }),
        (Object.keys(o).length || Object.keys(i).length) &&
          this.queue.push({ pending: i, pendingCount: Object.keys(i).length, loaded: {}, errors: [], callback: a }),
        {
          toLoad: Object.keys(o),
          pending: Object.keys(i),
          toLoadLanguages: Object.keys(s),
          toLoadNamespaces: Object.keys(l),
        }
      );
    }
    loaded(e, t, a) {
      var r = e.split('|');
      const n = r[0],
        o = r[1],
        i =
          (t && this.emit('failedLoading', n, o, t),
          a && this.store.addResourceBundle(n, o, a, void 0, void 0, { skipCopy: !0 }),
          (this.state[e] = t ? -1 : 2),
          {});
      this.queue.forEach((a) => {
        Je(a.loaded, [n], o),
          kt(a, e),
          t && a.errors.push(t),
          0 !== a.pendingCount ||
            a.done ||
            (Object.keys(a.loaded).forEach((t) => {
              i[t] || (i[t] = {});
              var e = a.loaded[t];
              e.length &&
                e.forEach((e) => {
                  void 0 === i[t][e] && (i[t][e] = !0);
                });
            }),
            (a.done = !0),
            a.errors.length ? a.callback(a.errors) : a.callback());
      }),
        this.emit('loaded', i),
        (this.queue = this.queue.filter((e) => !e.done));
    }
    read(r, n, o) {
      let i = 3 < arguments.length && void 0 !== arguments[3] ? arguments[3] : 0,
        s = 4 < arguments.length && void 0 !== arguments[4] ? arguments[4] : this.retryTimeout,
        l = 5 < arguments.length ? arguments[5] : void 0;
      if (!r.length) return l(null, {});
      if (this.readingCalls >= this.maxParallelReads)
        this.waitingReads.push({ lng: r, ns: n, fcName: o, tried: i, wait: s, callback: l });
      else {
        this.readingCalls++;
        const a = (e, t) => {
          var a;
          this.readingCalls--,
            0 < this.waitingReads.length &&
              ((a = this.waitingReads.shift()), this.read(a.lng, a.ns, a.fcName, a.tried, a.wait, a.callback)),
            e && t && i < this.maxRetries
              ? setTimeout(() => {
                  this.read.call(this, r, n, o, i + 1, 2 * s, l);
                }, s)
              : l(e, t);
        };
        var e = this.backend[o].bind(this.backend);
        if (2 !== e.length) return e(r, n, a);
        try {
          var t = e(r, n);
          t && 'function' == typeof t.then ? t.then((e) => a(null, e)).catch(a) : a(null, t);
        } catch (e) {
          a(e);
        }
      }
    }
    prepareLoading(e, t) {
      var a = 2 < arguments.length && void 0 !== arguments[2] ? arguments[2] : {},
        r = 3 < arguments.length ? arguments[3] : void 0;
      if (!this.backend)
        return this.logger.warn('No backend was added via i18next.use. Will not load resources.'), r && r();
      'string' == typeof e && (e = this.languageUtils.toResolveHierarchy(e));
      e = this.queueLoad(e, (t = 'string' == typeof t ? [t] : t), a, r);
      if (!e.toLoad.length) return e.pending.length || r(), null;
      e.toLoad.forEach((e) => {
        this.loadOne(e);
      });
    }
    load(e, t, a) {
      this.prepareLoading(e, t, {}, a);
    }
    reload(e, t, a) {
      this.prepareLoading(e, t, { reload: !0 }, a);
    }
    loadOne(a) {
      let r = 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : '';
      var e = a.split('|');
      const n = e[0],
        o = e[1];
      this.read(n, o, 'read', void 0, void 0, (e, t) => {
        e && this.logger.warn(`${r}loading namespace ${o} for language ${n} failed`, e),
          !e && t && this.logger.log(`${r}loaded namespace ${o} for language ` + n, t),
          this.loaded(a, e, t);
      });
    }
    saveMissing(t, a, r, n, o) {
      var i = 5 < arguments.length && void 0 !== arguments[5] ? arguments[5] : {};
      let s = 6 < arguments.length && void 0 !== arguments[6] ? arguments[6] : () => {};
      if (this.services.utils && this.services.utils.hasLoadedNamespace && !this.services.utils.hasLoadedNamespace(a))
        this.logger.warn(
          `did not save key "${r}" as the namespace "${a}" was not yet loaded`,
          'This means something IS WRONG in your setup. You access the t function before i18next.init / i18next.loadNamespace / i18next.changeLanguage was done. Wait for the callback or Promise to resolve before accessing it!!!',
        );
      else if (null != r && '' !== r) {
        if (this.backend && this.backend.create) {
          (i = { ...i, isUpdate: o }), (o = this.backend.create.bind(this.backend));
          if (o.length < 6)
            try {
              let e;
              (e = 5 === o.length ? o(t, a, r, n, i) : o(t, a, r, n)) && 'function' == typeof e.then
                ? e.then((e) => s(null, e)).catch(s)
                : s(null, e);
            } catch (e) {
              s(e);
            }
          else o(t, a, r, n, s, i);
        }
        t && t[0] && this.store.addResource(t[0], a, r, n);
      }
    }
  };
  function Et() {
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
          const a = e[3] || e[2];
          Object.keys(a).forEach((e) => {
            t[e] = a[e];
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
  function Ct(e) {
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
  function Nt() {}
  function xt(t) {
    Object.getOwnPropertyNames(Object.getPrototypeOf(t)).forEach((e) => {
      'function' == typeof t[e] && (t[e] = t[e].bind(t));
    });
  }
  var It = class extends r {
      constructor() {
        let e = 0 < arguments.length && void 0 !== arguments[0] ? arguments[0] : {},
          t = 1 < arguments.length ? arguments[1] : void 0;
        if (
          (super(),
          (this.options = Ct(e)),
          (this.services = {}),
          (this.logger = l),
          (this.modules = { external: [] }),
          xt(this),
          t && !this.isInitialized && !e.isClone)
        ) {
          if (!this.options.initImmediate) return this.init(e, t), this;
          setTimeout(() => {
            this.init(e, t);
          }, 0);
        }
      }
      init() {
        var n = this;
        let e = 0 < arguments.length && void 0 !== arguments[0] ? arguments[0] : {},
          a = 1 < arguments.length ? arguments[1] : void 0;
        (this.isInitializing = !0),
          'function' == typeof e && ((a = e), (e = {})),
          !e.defaultNS &&
            !1 !== e.defaultNS &&
            e.ns &&
            ('string' == typeof e.ns
              ? (e.defaultNS = e.ns)
              : e.ns.indexOf('translation') < 0 && (e.defaultNS = e.ns[0]));
        var t = Et();
        function r(e) {
          return e ? ('function' == typeof e ? new e() : e) : null;
        }
        if (
          ((this.options = { ...t, ...this.options, ...Ct(e) }),
          'v1' !== this.options.compatibilityAPI &&
            (this.options.interpolation = { ...t.interpolation, ...this.options.interpolation }),
          void 0 !== e.keySeparator && (this.options.userDefinedKeySeparator = e.keySeparator),
          void 0 !== e.nsSeparator && (this.options.userDefinedNsSeparator = e.nsSeparator),
          !this.options.isClone)
        ) {
          this.modules.logger ? l.init(r(this.modules.logger), this.options) : l.init(null, this.options);
          let e;
          this.modules.formatter ? (e = this.modules.formatter) : 'undefined' != typeof Intl && (e = St);
          var o = new ct(this.options),
            i = ((this.store = new nt(this.options.resources, this.options)), this.services);
          (i.logger = l),
            (i.resourceStore = this.store),
            (i.languageUtils = o),
            (i.pluralResolver = new gt(o, {
              prepend: this.options.pluralSeparator,
              compatibilityJSON: this.options.compatibilityJSON,
              simplifyPluralSuffix: this.options.simplifyPluralSuffix,
            })),
            !e ||
              (this.options.interpolation.format && this.options.interpolation.format !== t.interpolation.format) ||
              ((i.formatter = r(e)),
              i.formatter.init(i, this.options),
              (this.options.interpolation.format = i.formatter.format.bind(i.formatter))),
            (i.interpolator = new bt(this.options)),
            (i.utils = { hasLoadedNamespace: this.hasLoadedNamespace.bind(this) }),
            (i.backendConnector = new wt(r(this.modules.backend), i.resourceStore, i, this.options)),
            i.backendConnector.on('*', function (e) {
              for (var t = arguments.length, a = new Array(1 < t ? t - 1 : 0), r = 1; r < t; r++)
                a[r - 1] = arguments[r];
              n.emit(e, ...a);
            }),
            this.modules.languageDetector &&
              ((i.languageDetector = r(this.modules.languageDetector)), i.languageDetector.init) &&
              i.languageDetector.init(i, this.options.detection, this.options),
            this.modules.i18nFormat &&
              ((i.i18nFormat = r(this.modules.i18nFormat)), i.i18nFormat.init) &&
              i.i18nFormat.init(this),
            (this.translator = new st(this.services, this.options)),
            this.translator.on('*', function (e) {
              for (var t = arguments.length, a = new Array(1 < t ? t - 1 : 0), r = 1; r < t; r++)
                a[r - 1] = arguments[r];
              n.emit(e, ...a);
            }),
            this.modules.external.forEach((e) => {
              e.init && e.init(this);
            });
        }
        (this.format = this.options.interpolation.format),
          (a = a || Nt),
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
            return n.store[e](...arguments);
          };
        });
        ['addResource', 'addResources', 'addResourceBundle', 'removeResourceBundle'].forEach((e) => {
          this[e] = function () {
            return n.store[e](...arguments), n;
          };
        });
        const s = Fe();
        t = () => {
          var e = (e, t) => {
            (this.isInitializing = !1),
              this.isInitialized &&
                !this.initializedStoreOnce &&
                this.logger.warn('init: i18next is already initialized. You should call init just once!'),
              (this.isInitialized = !0),
              this.options.isClone || this.logger.log('initialized', this.options),
              this.emit('initialized', this.options),
              s.resolve(t),
              a(e, t);
          };
          if (this.languages && 'v1' !== this.options.compatibilityAPI && !this.isInitialized)
            return e(null, this.t.bind(this));
          this.changeLanguage(this.options.lng, e);
        };
        return this.options.resources || !this.options.initImmediate ? t() : setTimeout(t, 0), s;
      }
      loadResources(e) {
        let t = 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : Nt;
        var a = 'string' == typeof e ? e : this.language;
        if (('function' == typeof e && (t = e), !this.options.resources || this.options.partialBundledLanguages)) {
          if (a && 'cimode' === a.toLowerCase() && (!this.options.preload || 0 === this.options.preload.length))
            return t();
          const r = [],
            n = (e) => {
              e &&
                'cimode' !== e &&
                this.services.languageUtils.toResolveHierarchy(e).forEach((e) => {
                  'cimode' !== e && r.indexOf(e) < 0 && r.push(e);
                });
            };
          a ? n(a) : this.services.languageUtils.getFallbackCodes(this.options.fallbackLng).forEach((e) => n(e)),
            this.options.preload && this.options.preload.forEach((e) => n(e)),
            this.services.backendConnector.load(r, this.options.ns, (e) => {
              e || this.resolvedLanguage || !this.language || this.setResolvedLanguage(this.language), t(e);
            });
        } else t(null);
      }
      reloadResources(e, t, a) {
        const r = Fe();
        return (
          (e = e || this.languages),
          (t = t || this.options.ns),
          (a = a || Nt),
          this.services.backendConnector.reload(e, t, (e) => {
            r.resolve(), a(e);
          }),
          r
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
            'postProcessor' === e.type && ot.addPostProcessor(e),
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
      changeLanguage(a, r) {
        var n = this;
        this.isLanguageChangingTo = a;
        const o = Fe(),
          i =
            (this.emit('languageChanging', a),
            (e) => {
              (this.language = e),
                (this.languages = this.services.languageUtils.toResolveHierarchy(e)),
                (this.resolvedLanguage = void 0),
                this.setResolvedLanguage(e);
            }),
          s = (e, t) => {
            t
              ? (i(t),
                this.translator.changeLanguage(t),
                (this.isLanguageChangingTo = void 0),
                this.emit('languageChanged', t),
                this.logger.log('languageChanged', t))
              : (this.isLanguageChangingTo = void 0),
              o.resolve(function () {
                return n.t(...arguments);
              }),
              r &&
                r(e, function () {
                  return n.t(...arguments);
                });
          };
        var e = (e) => {
          const t =
            'string' == typeof (e = a || e || !this.services.languageDetector ? e : [])
              ? e
              : this.services.languageUtils.getBestMatchFromCodes(e);
          t &&
            (this.language || i(t),
            this.translator.language || this.translator.changeLanguage(t),
            this.services.languageDetector) &&
            this.services.languageDetector.cacheUserLanguage &&
            this.services.languageDetector.cacheUserLanguage(t),
            this.loadResources(t, (e) => {
              s(e, t);
            });
        };
        return (
          a || !this.services.languageDetector || this.services.languageDetector.async
            ? !a && this.services.languageDetector && this.services.languageDetector.async
              ? 0 === this.services.languageDetector.detect.length
                ? this.services.languageDetector.detect().then(e)
                : this.services.languageDetector.detect(e)
              : e(a)
            : e(this.services.languageDetector.detect()),
          o
        );
      }
      getFixedT(e, t, l) {
        var c = this;
        function u(e, t) {
          let a;
          if ('object' != typeof t) {
            for (var r = arguments.length, n = new Array(2 < r ? r - 2 : 0), o = 2; o < r; o++) n[o - 2] = arguments[o];
            a = c.options.overloadTranslationOptionHandler([e, t].concat(n));
          } else a = { ...t };
          (a.lng = a.lng || u.lng),
            (a.lngs = a.lngs || u.lngs),
            (a.ns = a.ns || u.ns),
            (a.keyPrefix = a.keyPrefix || l || u.keyPrefix);
          const i = c.options.keySeparator || '.';
          let s;
          return (
            (s =
              a.keyPrefix && Array.isArray(e)
                ? e.map((e) => '' + a.keyPrefix + i + e)
                : a.keyPrefix
                  ? '' + a.keyPrefix + i + e
                  : e),
            c.t(s, a)
          );
        }
        return 'string' == typeof e ? (u.lng = e) : (u.lngs = e), (u.ns = t), (u.keyPrefix = l), u;
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
        var a = t.lng || this.resolvedLanguage || this.languages[0],
          r = !!this.options && this.options.fallbackLng,
          n = this.languages[this.languages.length - 1];
        if ('cimode' === a.toLowerCase()) return !0;
        var o = (e, t) => {
          e = this.services.backendConnector.state[e + '|' + t];
          return -1 === e || 2 === e;
        };
        if (t.precheck) {
          t = t.precheck(this, o);
          if (void 0 !== t) return t;
        }
        return (
          !!this.hasResourceBundle(a, e) ||
          !(
            this.services.backendConnector.backend &&
            (!this.options.resources || this.options.partialBundledLanguages) &&
            (!o(a, e) || (r && !o(n, e)))
          )
        );
      }
      loadNamespaces(e, t) {
        const a = Fe();
        return this.options.ns
          ? ((e = 'string' == typeof e ? [e] : e).forEach((e) => {
              this.options.ns.indexOf(e) < 0 && this.options.ns.push(e);
            }),
            this.loadResources((e) => {
              a.resolve(), t && t(e);
            }),
            a)
          : (t && t(), Promise.resolve());
      }
      loadLanguages(e, t) {
        const a = Fe(),
          r = this.options.preload || [];
        e = (e = 'string' == typeof e ? [e] : e).filter(
          (e) => r.indexOf(e) < 0 && this.services.languageUtils.isSupportedCode(e),
        );
        return e.length
          ? ((this.options.preload = r.concat(e)),
            this.loadResources((e) => {
              a.resolve(), t && t(e);
            }),
            a)
          : (t && t(), Promise.resolve());
      }
      dir(e) {
        var t;
        return !(e =
          e ||
          this.resolvedLanguage ||
          (this.languages && 0 < this.languages.length ? this.languages[0] : this.language)) ||
          ((t = (this.services && this.services.languageUtils) || new ct(Et())),
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
        return new It(
          0 < arguments.length && void 0 !== arguments[0] ? arguments[0] : {},
          1 < arguments.length ? arguments[1] : void 0,
        );
      }
      cloneInstance() {
        var e = 0 < arguments.length && void 0 !== arguments[0] ? arguments[0] : {},
          t = 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : Nt,
          a = e.forkResourceStore,
          r = (a && delete e.forkResourceStore, { ...this.options, ...e, isClone: !0 });
        const n = new It(r);
        (void 0 === e.debug && void 0 === e.prefix) || (n.logger = n.logger.clone(e));
        return (
          ['store', 'services', 'language'].forEach((e) => {
            n[e] = this[e];
          }),
          (n.services = { ...this.services }),
          (n.services.utils = { hasLoadedNamespace: n.hasLoadedNamespace.bind(n) }),
          a && ((n.store = new nt(this.store.data, r)), (n.services.resourceStore = n.store)),
          (n.translator = new st(n.services, r)),
          n.translator.on('*', function (e) {
            for (var t = arguments.length, a = new Array(1 < t ? t - 1 : 0), r = 1; r < t; r++) a[r - 1] = arguments[r];
            n.emit(e, ...a);
          }),
          n.init(r, t),
          (n.translator.options = r),
          (n.translator.backendConnector.services.utils = { hasLoadedNamespace: n.hasLoadedNamespace.bind(n) }),
          n
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
    },
    r = It.createInstance(),
    y =
      ((r.createInstance = It.createInstance),
      r.createInstance,
      r.dir,
      r.init,
      r.loadResources,
      r.reloadResources,
      r.use,
      r.changeLanguage,
      r.getFixedT,
      r.t);
  r.exists,
    r.setDefaultNamespace,
    r.hasLoadedNamespace,
    r.loadNamespaces,
    r.loadLanguages,
    t(b(), 1),
    t(b(), 1),
    t(z());
  var Lt = {};
  function Ot() {
    for (var e = arguments.length, t = new Array(e), a = 0; a < e; a++) t[a] = arguments[a];
    ('string' == typeof t[0] && Lt[t[0]]) ||
      ('string' == typeof t[0] && (Lt[t[0]] = new Date()),
      (function () {
        if (console && console.warn) {
          for (var e = arguments.length, t = new Array(e), a = 0; a < e; a++) t[a] = arguments[a];
          'string' == typeof t[0] && (t[0] = 'react-i18next:: ' + t[0]), console.warn(...t);
        }
      })(...t));
  }
  var Tt = (t, a) => () => {
    if (t.isInitialized) a();
    else {
      const e = () => {
        setTimeout(() => {
          t.off('initialized', e);
        }, 0),
          a();
      };
      t.on('initialized', e);
    }
  };
  function At(e, t, a) {
    e.loadNamespaces(t, Tt(e, a));
  }
  function Pt(t, e, a, r) {
    (a = 'string' == typeof a ? [a] : a).forEach((e) => {
      t.options.ns.indexOf(e) < 0 && t.options.ns.push(e);
    }),
      t.loadLanguages(e, Tt(t, r));
  }
  function Mt(a, e, t) {
    let r = 2 < arguments.length && void 0 !== t ? t : {};
    return e.languages && e.languages.length
      ? void 0 !== e.options.ignoreJSONStructure
        ? e.hasLoadedNamespace(a, {
            lng: r.lng,
            precheck: (e, t) => {
              if (
                r.bindI18n &&
                -1 < r.bindI18n.indexOf('languageChanging') &&
                e.services.backendConnector.backend &&
                e.isLanguageChangingTo &&
                !t(e.isLanguageChangingTo, a)
              )
                return !1;
            },
          })
        : (function (e, a, t) {
            var r,
              n = 2 < arguments.length && void 0 !== t ? t : {},
              o = a.languages[0],
              i = !!a.options && a.options.fallbackLng,
              s = a.languages[a.languages.length - 1];
            return (
              'cimode' === o.toLowerCase() ||
              ((r = (e, t) => {
                e = a.services.backendConnector.state[e + '|' + t];
                return -1 === e || 2 === e;
              }),
              !(
                (n.bindI18n &&
                  -1 < n.bindI18n.indexOf('languageChanging') &&
                  a.services.backendConnector.backend &&
                  a.isLanguageChangingTo &&
                  !r(a.isLanguageChangingTo, e)) ||
                (!a.hasResourceBundle(o, e) &&
                  a.services.backendConnector.backend &&
                  (!a.options.resources || a.options.partialBundledLanguages) &&
                  (!r(o, e) || (i && !r(s, e))))
              ))
            );
          })(a, e, r)
      : (Ot('i18n.languages were undefined or empty', e.languages), !0);
  }
  var _t,
    Rt = /&(?:amp|#38|lt|#60|gt|#62|apos|#39|quot|#34|nbsp|#160|copy|#169|reg|#174|hellip|#8230|#x2F|#47);/g,
    jt = {
      '&amp;': '&',
      '&#38;': '&',
      '&lt;': '<',
      '&#60;': '<',
      '&gt;': '>',
      '&#62;': '>',
      '&apos;': "'",
      '&#39;': "'",
      '&quot;': '"',
      '&#34;': '"',
      '&nbsp;': ' ',
      '&#160;': ' ',
      '&copy;': '©',
      '&#169;': '©',
      '&reg;': '®',
      '&#174;': '®',
      '&hellip;': '…',
      '&#8230;': '…',
      '&#x2F;': '/',
      '&#47;': '/',
    },
    Dt = (e) => jt[e],
    $t = {
      bindI18n: 'languageChanged',
      bindI18nStore: '',
      transEmptyNodeValue: '',
      transSupportBasicHtmlNodes: !0,
      transWrapTextNodes: '',
      transKeepBasicHtmlNodesFor: ['br', 'strong', 'i', 'p'],
      useSuspense: !0,
      unescape: (e) => e.replace(Rt, Dt),
    };
  var z = {
      type: '3rdParty',
      init(e) {
        !(function (e) {
          var t = 0 < arguments.length && void 0 !== e ? e : {};
          $t = { ...$t, ...t };
        })(e.options.react),
          (_t = e);
      },
    },
    zt = (0, t(b(), 1).createContext)(),
    Ut = class {
      constructor() {
        this.usedNamespaces = {};
      }
      addUsedNamespaces(e) {
        e.forEach((e) => {
          this.usedNamespaces[e] || (this.usedNamespaces[e] = !0);
        });
      }
      getUsedNamespaces() {
        return Object.keys(this.usedNamespaces);
      }
    },
    k = t(b(), 1),
    Bt = (e, t) => {
      const a = (0, k.useRef)();
      return (
        (0, k.useEffect)(() => {
          a.current = t ? a.current : e;
        }, [e, t]),
        a.current
      );
    };
  function Ft(e, t, a, r) {
    return e.getFixedT(t, a, r);
  }
  function Vt(e, t) {
    let r = 1 < arguments.length && void 0 !== t ? t : {};
    var a,
      n = r['i18n'],
      { i18n: o, defaultNS: i } = (0, k.useContext)(zt) || {};
    const s = n || o || _t;
    if ((s && !s.reportNamespaces && (s.reportNamespaces = new Ut()), !s))
      return (
        Ot('You will need to pass in an i18next instance by using initReactI18next'),
        ((o = [
          (n = (e, t) =>
            'string' == typeof t
              ? t
              : t && 'object' == typeof t && 'string' == typeof t.defaultValue
                ? t.defaultValue
                : Array.isArray(e)
                  ? e[e.length - 1]
                  : e),
          {},
          !1,
        ]).t = n),
        (o.i18n = {}),
        (o.ready = !1),
        o
      );
    s.options.react &&
      void 0 !== s.options.react.wait &&
      Ot('It seems you are still using the old wait option, you may migrate to the new useSuspense behaviour.');
    const l = { ...$t, ...s.options.react, ...r },
      { useSuspense: c, keyPrefix: u } = l;
    let d = e || i || (s.options && s.options.defaultNS);
    (d = 'string' == typeof d ? [d] : d || ['translation']),
      s.reportNamespaces.addUsedNamespaces && s.reportNamespaces.addUsedNamespaces(d);
    const p = (s.isInitialized || s.initializedStoreOnce) && d.every((e) => Mt(e, s, l)),
      h =
        ((n = s),
        (o = r.lng || null),
        (i = 'fallback' === l.nsMode ? d : d[0]),
        (a = u),
        (0, k.useCallback)(Ft(n, o, i, a), [n, o, i, a])),
      m = () => h,
      f = () => Ft(s, r.lng || null, 'fallback' === l.nsMode ? d : d[0], u),
      [g, v] = (0, k.useState)(m);
    let b = d.join();
    r.lng && (b = '' + r.lng + b);
    const y = Bt(b),
      S = (0, k.useRef)(!0);
    (0, k.useEffect)(() => {
      const { bindI18n: e, bindI18nStore: t } = l;
      function a() {
        S.current && v(f);
      }
      return (
        (S.current = !0),
        p ||
          c ||
          (r.lng
            ? Pt(s, r.lng, d, () => {
                S.current && v(f);
              })
            : At(s, d, () => {
                S.current && v(f);
              })),
        p && y && y !== b && S.current && v(f),
        e && s && s.on(e, a),
        t && s && s.store.on(t, a),
        () => {
          (S.current = !1),
            e && s && e.split(' ').forEach((e) => s.off(e, a)),
            t && s && t.split(' ').forEach((e) => s.store.off(e, a));
        }
      );
    }, [s, b]),
      (0, k.useEffect)(() => {
        S.current && p && v(m);
      }, [s, u, p]);
    n = [g, s, p];
    if (((n.t = g), (n.i18n = s), (n.ready = p) || (!p && !c))) return n;
    throw new Promise((e) => {
      r.lng ? Pt(s, r.lng, d, () => e()) : At(s, d, () => e());
    });
  }
  var Ht = t(b(), 1);
  function qt(i, e) {
    let s = 1 < arguments.length && void 0 !== e ? e : {};
    return function (o) {
      function a(e) {
        let { forwardedRef: t, ...a } = e;
        var [e, r, n] = Vt(i, { ...a, keyPrefix: s.keyPrefix }),
          e = { ...a, t: e, i18n: r, tReady: n };
        return s.withRef && t ? (e.ref = t) : !s.withRef && t && (e.forwardedRef = t), (0, Ht.createElement)(o, e);
      }
      var e;
      (a.displayName = `withI18nextTranslation(${((e = o), e.displayName || e.name || ('string' == typeof e && 0 < e.length ? e : 'Unknown'))})`),
        (a.WrappedComponent = o);
      return s.withRef
        ? (0, Ht.forwardRef)((e, t) => (0, Ht.createElement)(a, Object.assign({}, e, { forwardedRef: t })))
        : a;
    };
  }
  t(b(), 1), t(b(), 1), t(b(), 1);
  function Gt(e) {
    return (Gt =
      'function' == typeof Symbol && 'symbol' == typeof Symbol.iterator
        ? function (e) {
            return typeof e;
          }
        : function (e) {
            return e && 'function' == typeof Symbol && e.constructor === Symbol && e !== Symbol.prototype
              ? 'symbol'
              : typeof e;
          })(e);
  }
  function Kt(e) {
    e = (function (e, t) {
      if ('object' !== Gt(e) || null === e) return e;
      var a = e[Symbol.toPrimitive];
      if (void 0 === a) return ('string' === t ? String : Number)(e);
      if ('object' !== Gt((a = a.call(e, t || 'default')))) return a;
      throw new TypeError('@@toPrimitive must return a primitive value.');
    })(e, 'string');
    return 'symbol' === Gt(e) ? e : String(e);
  }
  function Jt(e, t) {
    for (var a = 0; a < t.length; a++) {
      var r = t[a];
      (r.enumerable = r.enumerable || !1),
        (r.configurable = !0),
        'value' in r && (r.writable = !0),
        Object.defineProperty(e, Kt(r.key), r);
    }
  }
  var Wt = [],
    Zt = Wt.forEach,
    Xt = Wt.slice;
  function Yt() {
    if (null === oa)
      try {
        oa = 'undefined' !== window && null !== window.localStorage;
        var e = 'i18next.translate.boo';
        window.localStorage.setItem(e, 'foo'), window.localStorage.removeItem(e);
      } catch (e) {
        oa = !1;
      }
    return oa;
  }
  function Qt() {
    if (null === sa)
      try {
        sa = 'undefined' !== window && null !== window.sessionStorage;
        var e = 'i18next.translate.boo';
        window.sessionStorage.setItem(e, 'foo'), window.sessionStorage.removeItem(e);
      } catch (e) {
        sa = !1;
      }
    return sa;
  }
  var ea = /^[\u0009\u0020-\u007e\u0080-\u00ff]+$/,
    ta = function (e, t, a, r) {
      var n = 4 < arguments.length && void 0 !== arguments[4] ? arguments[4] : { path: '/', sameSite: 'strict' };
      a && ((n.expires = new Date()), n.expires.setTime(n.expires.getTime() + 60 * a * 1e3)),
        r && (n.domain = r),
        (document.cookie = (function (e, t, a) {
          var a = a || {},
            t = ((a.path = a.path || '/'), encodeURIComponent(t)),
            r = ''.concat(e, '=').concat(t);
          if (0 < a.maxAge) {
            e = +a.maxAge;
            if (Number.isNaN(e)) throw new Error('maxAge should be a Number');
            r += '; Max-Age='.concat(Math.floor(e));
          }
          if (a.domain) {
            if (!ea.test(a.domain)) throw new TypeError('option domain is invalid');
            r += '; Domain='.concat(a.domain);
          }
          if (a.path) {
            if (!ea.test(a.path)) throw new TypeError('option path is invalid');
            r += '; Path='.concat(a.path);
          }
          if (a.expires) {
            if ('function' != typeof a.expires.toUTCString) throw new TypeError('option expires is invalid');
            r += '; Expires='.concat(a.expires.toUTCString());
          }
          if ((a.httpOnly && (r += '; HttpOnly'), a.secure && (r += '; Secure'), a.sameSite))
            switch ('string' == typeof a.sameSite ? a.sameSite.toLowerCase() : a.sameSite) {
              case !0:
                r += '; SameSite=Strict';
                break;
              case 'lax':
                r += '; SameSite=Lax';
                break;
              case 'strict':
                r += '; SameSite=Strict';
                break;
              case 'none':
                r += '; SameSite=None';
                break;
              default:
                throw new TypeError('option sameSite is invalid');
            }
          return r;
        })(e, encodeURIComponent(t), n));
    },
    aa = function (e) {
      for (var t = ''.concat(e, '='), a = document.cookie.split(';'), r = 0; r < a.length; r++) {
        for (var n = a[r]; ' ' === n.charAt(0); ) n = n.substring(1, n.length);
        if (0 === n.indexOf(t)) return n.substring(t.length, n.length);
      }
      return null;
    },
    ra = {
      name: 'cookie',
      lookup: function (e) {
        var t;
        return (t = e.lookupCookie && 'undefined' != typeof document && (e = aa(e.lookupCookie)) ? e : t);
      },
      cacheUserLanguage: function (e, t) {
        t.lookupCookie &&
          'undefined' != typeof document &&
          ta(t.lookupCookie, e, t.cookieMinutes, t.cookieDomain, t.cookieOptions);
      },
    },
    na = {
      name: 'querystring',
      lookup: function (e) {
        var t;
        if ('undefined' != typeof window)
          for (
            var a = window.location.search,
              r = (a =
                !window.location.search && window.location.hash && -1 < window.location.hash.indexOf('?')
                  ? window.location.hash.substring(window.location.hash.indexOf('?'))
                  : a)
                .substring(1)
                .split('&'),
              n = 0;
            n < r.length;
            n++
          ) {
            var o = r[n].indexOf('=');
            0 < o && r[n].substring(0, o) === e.lookupQuerystring && (t = r[n].substring(o + 1));
          }
        return t;
      },
    },
    oa = null,
    ia = {
      name: 'localStorage',
      lookup: function (e) {
        var t;
        return (t = e.lookupLocalStorage && Yt() && (e = window.localStorage.getItem(e.lookupLocalStorage)) ? e : t);
      },
      cacheUserLanguage: function (e, t) {
        t.lookupLocalStorage && Yt() && window.localStorage.setItem(t.lookupLocalStorage, e);
      },
    },
    sa = null,
    la = {
      name: 'sessionStorage',
      lookup: function (e) {
        var t;
        return (t =
          e.lookupSessionStorage && Qt() && (e = window.sessionStorage.getItem(e.lookupSessionStorage)) ? e : t);
      },
      cacheUserLanguage: function (e, t) {
        t.lookupSessionStorage && Qt() && window.sessionStorage.setItem(t.lookupSessionStorage, e);
      },
    },
    ca = {
      name: 'navigator',
      lookup: function (e) {
        var t = [];
        if ('undefined' != typeof navigator) {
          if (navigator.languages) for (var a = 0; a < navigator.languages.length; a++) t.push(navigator.languages[a]);
          navigator.userLanguage && t.push(navigator.userLanguage), navigator.language && t.push(navigator.language);
        }
        return 0 < t.length ? t : void 0;
      },
    },
    ua = {
      name: 'htmlTag',
      lookup: function (e) {
        var t,
          e = e.htmlTag || ('undefined' != typeof document ? document.documentElement : null);
        return (t = e && 'function' == typeof e.getAttribute ? e.getAttribute('lang') : t);
      },
    },
    da = {
      name: 'path',
      lookup: function (e) {
        var t;
        if ('undefined' != typeof window) {
          var a = window.location.pathname.match(/\/([a-zA-Z-]*)/g);
          if (a instanceof Array)
            if ('number' == typeof e.lookupFromPathIndex) {
              if ('string' != typeof a[e.lookupFromPathIndex]) return;
              t = a[e.lookupFromPathIndex].replace('/', '');
            } else t = a[0].replace('/', '');
        }
        return t;
      },
    },
    pa = {
      name: 'subdomain',
      lookup: function (e) {
        var e = 'number' == typeof e.lookupFromSubdomainIndex ? e.lookupFromSubdomainIndex + 1 : 1,
          t =
            'undefined' != typeof window &&
            window.location &&
            window.location.hostname &&
            window.location.hostname.match(/^(\w{2,5})\.(([a-z0-9-]{1,63}\.[a-z]{2,6})|localhost)/i);
        if (t) return t[e];
      },
    };
  var Wt = (function () {
      function n(e) {
        var t = 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : {},
          a = this,
          r = n;
        if (!(a instanceof r)) throw new TypeError('Cannot call a class as a function');
        (this.type = 'languageDetector'), (this.detectors = {}), this.init(e, t);
      }
      var e, t, a;
      return (
        (e = n),
        (t = [
          {
            key: 'init',
            value: function (e) {
              var t = 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : {},
                a = 2 < arguments.length && void 0 !== arguments[2] ? arguments[2] : {};
              (this.services = e || { languageUtils: {} }),
                (this.options = (function (a) {
                  return (
                    Zt.call(Xt.call(arguments, 1), function (e) {
                      if (e) for (var t in e) void 0 === a[t] && (a[t] = e[t]);
                    }),
                    a
                  );
                })(t, this.options || {}, {
                  order: ['querystring', 'cookie', 'localStorage', 'sessionStorage', 'navigator', 'htmlTag'],
                  lookupQuerystring: 'lng',
                  lookupCookie: 'i18next',
                  lookupLocalStorage: 'i18nextLng',
                  lookupSessionStorage: 'i18nextLng',
                  caches: ['localStorage'],
                  excludeCacheFor: ['cimode'],
                  convertDetectedLanguage: function (e) {
                    return e;
                  },
                })),
                'string' == typeof this.options.convertDetectedLanguage &&
                  -1 < this.options.convertDetectedLanguage.indexOf('15897') &&
                  (this.options.convertDetectedLanguage = function (e) {
                    return e.replace('-', '_');
                  }),
                this.options.lookupFromUrlIndex && (this.options.lookupFromPathIndex = this.options.lookupFromUrlIndex),
                (this.i18nOptions = a),
                this.addDetector(ra),
                this.addDetector(na),
                this.addDetector(ia),
                this.addDetector(la),
                this.addDetector(ca),
                this.addDetector(ua),
                this.addDetector(da),
                this.addDetector(pa);
            },
          },
          {
            key: 'addDetector',
            value: function (e) {
              this.detectors[e.name] = e;
            },
          },
          {
            key: 'detect',
            value: function (e) {
              var t = this,
                a = ((e = e || this.options.order), []);
              return (
                e.forEach(function (e) {
                  t.detectors[e] &&
                    (e = (e = t.detectors[e].lookup(t.options)) && 'string' == typeof e ? [e] : e) &&
                    (a = a.concat(e));
                }),
                (a = a.map(function (e) {
                  return t.options.convertDetectedLanguage(e);
                })),
                this.services.languageUtils.getBestMatchFromCodes ? a : 0 < a.length ? a[0] : null
              );
            },
          },
          {
            key: 'cacheUserLanguage',
            value: function (t, e) {
              var a = this;
              !(e = e || this.options.caches) ||
                (this.options.excludeCacheFor && -1 < this.options.excludeCacheFor.indexOf(t)) ||
                e.forEach(function (e) {
                  a.detectors[e] && a.detectors[e].cacheUserLanguage(t, a.options);
                });
            },
          },
        ]) && Jt(e.prototype, t),
        a && Jt(e, a),
        Object.defineProperty(e, 'prototype', { writable: !1 }),
        n
      );
    })(),
    ha =
      ((Wt.type = 'languageDetector'),
      {
        ca: {
          translation: {
            settings: {
              title: 'Configuració',
              optionsHeading: 'Opcions',
              starCountLabel: "Número d'estrelles",
              tagsLabel: 'Etiquetes',
              devToolsLabel: 'Eines per a desenvolupadors de temes',
              hideInstalledLabel: 'Amagar instal·lats',
              colourShiftLabel: 'Canviar colors cada minut',
              albumArtBasedColors: "Canviar colors a partir de la portada de l'àlbum",
              albumArtBasedColorsMode: 'Mode esquema de colors (ColorApi)',
              albumArtBasedColorsVibrancy: "Colors agafats de la portada de l'àlbum",
              albumArtBasedColorsVibrancyToolTip:
                "Desaturat:El color més destacat però amb molta menys bror \n Vibrant Clar: El color més villantibrant amb la brillantor augmentada una mica \n Prominent: El color més destacat a la portada de l'Àlbum \n Vibrant: El color més vibrant a la portada de l'Àlbum",
              almbumArtColorsModeToolTip:
                "Monochrome Dark: Un esquema de colors basat en el color principal seleccionat, emprant diferentes tonalitats i barrejant tons grisos per crear l'esquema de colors, aquest és l'invers de Monochrome Light. \n Monochrome Light: Un esquema de colors basat en el color principal seleccionat, emprant diferentes tonalitats i barrejant tons grisos per crear l'esquema de colors. El colors del fins de Monochrome light seria el color de primer pla en Monochrome Dark i viceversa. \n Analògic: Un esquema de colors basat en el color principal seleccionat, emprant els colors adjacents en la roda de colors. \n Analògic Complementari: Un esquema de colors basat en el color principal seleccionat, emprant els colors adjacents en la roda de colors i el color complementari. \n Tríada: Un esquema de colors basat en el color principal seleccionat, emprant els colors de la roda de colors que estan separats de manera equidistant del color principal. \n Quad: Un esquema de colors basat en el color principal seleccionat, emprant els colors que es troben separats 90 graus entre si en la roda de colors.",
              tabsHeading: 'Pestanyes',
              resetHeading: 'Restablir',
              resetBtn: '$t(settings.resetHeading)',
              resetDescription: 'Borrar totes les extensions, temes i preferències',
              backupHeading: "Fer una còpia/Reestablir des d'una còpia",
              backupLabel:
                "Fer una còpia o restablir totes les dades de Marketplace des d'una còpia. Això no inclou la configuració per els elements instal·lats amb Marketplace.",
              backupBtn: 'Obrir',
              versionHeading: 'Versió',
              versionBtn: 'Copiar',
              versionCopied: 'Copiat',
            },
            tabs: {
              Extensions: 'Extensions',
              Themes: 'Temes',
              Snippets: 'Fragments',
              Apps: 'Aplicacions',
              Installed: 'Instal·lats',
            },
            snippets: {
              addTitle: 'Afegir fragment',
              editTitle: 'Editar fragment',
              viewTitle: 'Veure fragment',
              customCSS: 'CSS personalitzat',
              customCSSPlaceholder:
                "Crea el teu propi CSS aqui! Pots trobar-los a la pestanya d'instal·lats per administrar-los.",
              snippetName: 'Nom del fragment de codi',
              snippetNamePlaceholder: 'Afegeix un nom al teu codi personalitzat',
              snippetDesc: 'Descripció del codi',
              snippetDescPlaceholder: 'Crea una descripció per al teu codi personalitzat',
              snippetPreview: 'Vista prèvia del fragment',
              optional: 'Opcional',
              addImage: 'Afegir imatge',
              changeImage: 'Canviar imatge',
              saveCSS: 'Guardar CSS',
            },
            reloadModal: {
              title: 'Recarregar',
              description: 'És necessari recarregar la finestra per completar aquesta operació.',
              reloadNow: 'Fes-ho ara',
              reloadLater: 'Després',
            },
            backupModal: {
              title: '$t(settings.backupHeading)',
              settingsCopied: 'Configuració copiada al portapapers',
              noDataPasted: "No s'han enganxat dades",
              invalidJSON: 'JSON invàlid',
              inputLabel: 'Configuració de Marketplace',
              inputPlaceholder: 'Còpia/enganxa la teva configuració aquí',
              exportBtn: 'Exportar',
              importBtn: 'Importar',
              fileImportBtn: "Importar des d'un arxiu",
            },
            devTools: {
              title: 'Eines de desenvolupador de temes',
              noThemeInstalled: 'Error: No hi ha cap tema de Marketplace instal·lat',
              noThemeManifest: "Error: No s'ha trobat el manifest",
              colorIniEditor: 'Editor de Color.ini',
              colorIniEditorPlaceholder: '[nom-de-esquema-de-color]',
              invalidCSS: 'CSS invàlid',
            },
            grid: {
              spicetifyMarketplace: 'Marketplace de Spicetify',
              newUpdate: 'Nova Actualització',
              addCSS: 'Afegir CSS',
              search: 'Buscar',
              installed: 'Instal·lat',
              lastUpdated: 'Última actualizació {{val, datetime}}',
              externalJS: 'JS extern',
              dark: 'fosc',
              light: 'clar',
            },
            readmePage: {
              title: '$t(grid.spicetifyMarketplace) - Readme',
              loading: 'Carregant...',
              errorLoading: 'Error carregant el README',
            },
            github: 'GitHub',
            install: 'Instal·lar',
            remove: 'Borrar',
            save: 'Guardar',
            colour_one: 'color',
            colour_other: 'colors',
            favourite: 'preferit',
          },
        },
        en: {
          translation: {
            settings: {
              title: 'Marketplace Settings',
              optionsHeading: 'Options',
              starCountLabel: 'Stars count',
              tagsLabel: 'Tags',
              showArchived: 'Show archived repos',
              devToolsLabel: 'Theme developer tools',
              hideInstalledLabel: 'Hide installed when browsing',
              colourShiftLabel: 'Shift colours every minute',
              albumArtBasedColors: 'Change colours based on album art',
              albumArtBasedColorsMode: 'Colour scheme (ColorApi) mode',
              albumArtBasedColorsVibrancy: 'Colour grabbed from album art',
              albumArtBasedColorsVibrancyToolTip:
                'Desaturated: The colour that is the most prominent but with much less brightness \n Light Vibrant: The most Vibrant colour but with the brightness amped up a tad \n Prominent: The colour that pops the most in the album art \n Vibrant: The most vibrant colour in the album art',
              almbumArtColorsModeToolTip:
                'Monochrome Dark: A colour scheme based directly on the main colour selected, using different shades of the main colour and mixing in greys to create a colour scheme, this is the inverse of Monochrome Light. \n Monochrome Light: A colour scheme based directly on the main colour selected, using different shades of the main colour and mixing in greys to create a colour scheme. The background of monochrome light would be the foreground or text colour on Monochrome Dark and vice versa. \n Analogic: A colour scheme based on the main colour selected, using the colours adjacent to the main colour on the colour wheel. \n Analogic Complementary: A colour scheme based on the main colour selected, using the colours adjacent to the main colour on the colour wheel and the complementary colour. \n Triad: A colour scheme based on the main colour selected, using the colours on the colour wheel that are equidistant from the main colour. \n Quad: A colour scheme based on the main colour selected, using the colours on the colour wheel that are 90 degrees from the main colour.',
              tabsHeading: 'Tabs',
              resetHeading: 'Reset',
              resetBtn: '$t(settings.resetHeading)',
              resetDescription: 'Uninstall all extensions and themes, and reset preferences',
              backupHeading: 'Back up/Restore',
              backupLabel:
                'Back up or restore all Marketplace data. This does not include settings for anything installed via Marketplace.',
              backupBtn: 'Open',
              versionHeading: 'Version',
              versionBtn: 'Copy',
              versionCopied: 'Copied',
            },
            tabs: {
              Extensions: 'Extensions',
              Themes: 'Themes',
              Snippets: 'Snippets',
              Apps: 'Apps',
              Installed: 'Installed',
            },
            snippets: {
              addTitle: 'Add Snippet',
              duplicateName: 'That name is already taken!',
              editTitle: 'Edit Snippet',
              viewTitle: 'View Snippet',
              customCSS: 'Custom CSS',
              customCSSPlaceholder:
                'Input your own custom CSS here! You can find them in the installed tab for management.',
              snippetName: 'Snippet Name',
              snippetNamePlaceholder: 'Enter a name for your custom snippet',
              snippetDesc: 'Snippet Description',
              snippetDescPlaceholder: 'Enter a description for your custom snippet',
              snippetPreview: 'Snippet Preview',
              optional: 'Optional',
              addImage: 'Add image',
              changeImage: 'Change image',
              saveCSS: 'Save CSS',
            },
            reloadModal: {
              title: 'Reload',
              description: 'A page reload is required to complete this operation.',
              reloadNow: 'Reload now',
              reloadLater: 'Reload later',
            },
            backupModal: {
              title: '$t(settings.backupHeading)',
              settingsCopied: 'Settings copied to clipboard',
              noDataPasted: 'No data pasted',
              invalidJSON: 'Invalid JSON',
              inputLabel: 'Marketplace Settings',
              inputPlaceholder: 'Copy/paste your settings here',
              exportBtn: 'Export',
              importBtn: 'Import',
              fileImportBtn: 'Import from file',
            },
            devTools: {
              title: 'Theme Dev Tools',
              noThemeInstalled: 'Error: No marketplace theme installed',
              noThemeManifest: 'Error: No theme manifest found',
              colorIniEditor: 'Color.ini Editor',
              colorIniEditorPlaceholder: '[your-colour-scheme-name]',
              invalidCSS: 'Invalid CSS',
            },
            updateModal: {
              title: 'Update the Marketplace',
              description: 'Update Spicetify Marketplace to receive new features and bug fixes.',
              currentVersion: 'Current version: {{version}}',
              latestVersion: 'Latest version: {{version}}',
              whatsChanged: "What's Changed",
              seeChangelog: 'See changelog',
              howToUpgrade: 'How to upgrade',
              viewGuide: 'View guide',
            },
            grid: {
              spicetifyMarketplace: 'Spicetify Marketplace',
              newUpdate: 'New update',
              addCSS: 'Add CSS',
              search: 'Search',
              installed: 'Installed',
              lastUpdated: 'Last updated {{val, datetime}}',
              externalJS: 'external JS',
              archived: 'archived',
              dark: 'dark',
              light: 'light',
              sort: {
                label: 'Sort by:',
                stars: 'Stars',
                newest: 'Newest',
                oldest: 'Oldest',
                lastUpdated: 'Last Updated',
                mostStale: 'Most Stale',
                aToZ: 'A-Z',
                zToA: 'Z-A',
              },
            },
            readmePage: {
              title: '$t(grid.spicetifyMarketplace) - Readme',
              loading: 'Loading...',
              errorLoading: 'Error loading README',
            },
            github: 'GitHub',
            install: 'Install',
            remove: 'Remove',
            save: 'Save',
            colour_one: 'colour',
            colour_other: 'colours',
            favourite: 'favourite',
            notifications: {
              wrongLocalTheme:
                "Please set current_theme in config-xpui.ini to 'marketplace' to install themes using the Marketplace",
              tooManyRequests: 'Too many requests, cool down',
              noCdnConnection: 'Marketplace is unable to connect to the CDN. Please check your Internet configuration',
              markdownParsingError: 'Error parsing markdown (HTTP {{status}})',
              noReadmeFile: 'No README was found',
              themeInstallationError: 'There was an error installing theme',
              extensionInstallationError: 'There was an error installing extension',
            },
          },
        },
        'en-US': {
          translation: {
            settings: {
              colourShiftLabel: 'Shift colors every minute',
              albumArtBasedColors: 'Change colors based on album art',
              albumArtBasedColorsMode: 'Color scheme (ColorApi) mode',
              albumArtBasedColorsVibrancy: 'Color grabbed from album art',
              albumArtBasedColorsVibrancyToolTip:
                'Desaturated: The color that is the most prominent but with much less brightness \n Light Vibrant: The most Vibrant color but with the brightness amped up a tad \n Prominent: The color that pops the most in the album art \n Vibrant: The most vibrant color in the album art',
              almbumArtColorsModeToolTip:
                'Monochrome Dark: A color scheme based directly on the main color selected, using different shades of the main color and mixing in greys to create a color scheme, this is the inverse of Monochrome Light. \n Monochrome Light: A color scheme based directly on the main color selected, using different shades of the main color and mixing in greys to create a color scheme. The background of monochrome light would be the foreground or text color on Monochrome Dark and vice versa. \n Analogic: A color scheme based on the main color selected, using the colors adjacent to the main color on the color wheel. \n Analogic Complementary: A color scheme based on the main color selected, using the colors adjacent to the main color on the color wheel and the complementary color. \n Triad: A color scheme based on the main color selected, using the colors on the color wheel that are equidistant from the main color. \n Quad: A color scheme based on the main color selected, using the colors on the color wheel that are 90 degrees from the main color.',
            },
            devTools: { colorIniEditorPlaceholder: '[your-color-scheme-name]' },
            colour_one: 'color',
            colour_other: 'colors',
            favourite: 'favorite',
          },
        },
        es: {
          translation: {
            settings: {
              title: 'Ajustes',
              optionsHeading: 'Opciones',
              starCountLabel: 'Numero de estrellas',
              tagsLabel: 'Etiquetas',
              devToolsLabel: 'Herramientas para desarrolladores de temas',
              hideInstalledLabel: 'Esconder instalado cuando buscando',
              colourShiftLabel: 'Cambiar colores cada minuto',
              tabsHeading: 'Pestañas',
              resetHeading: 'Reestablecer',
              resetBtn: '$t(settings.resetHeading)',
              resetDescription: 'Borrar todas estensiones and temas, y borrar preferencias',
              backupHeading: 'Haz una copia/Reestablecer desde una copia',
              backupLabel:
                'Haz una copia o reestablece todos los datos de Marketplace desde una copia. Esto no incluye ajustes para las cosas instaladas con Marketplace.',
              backupBtn: 'Abrir',
            },
            tabs: {
              Extensions: 'Extensiónes',
              Themes: 'Temas',
              Snippets: 'Codigos',
              Apps: 'Aplicaciones',
              Installed: 'Instalados',
            },
            snippets: {
              addTitle: 'Añadir Codigo',
              editTitle: 'Editar Codigo',
              viewTitle: 'Ver Codigo',
              customCSS: 'Custom CSS',
              customCSSPlaceholder:
                '¡Crea tu propio CSS aqui! Puedes encontrarlos en la pestaña de instalados para administrarlos.',
              snippetName: 'Nombre del codigo',
              snippetNamePlaceholder: 'Asignale un nombre para tu codigo personalizado',
              snippetDesc: 'Descripcion del codigo',
              snippetDescPlaceholder: 'Crea una description para tu codigo personalizado',
              snippetPreview: 'Codigo',
              optional: 'Opcional',
              addImage: 'Añadir imagen',
              changeImage: 'Cambiar imagen',
              saveCSS: 'Guardar CSS',
            },
            reloadModal: {
              title: 'Recargar',
              description: 'Una recarga de ventada es necesaria para completar esta operación.',
              reloadNow: 'Recargar ahora',
              reloadLater: 'Recargar después',
            },
            backupModal: {
              title: '$t(settings.backupHeading)',
              settingsCopied: 'Ajustes copiados al portapapeles',
              noDataPasted: 'No data pegado',
              invalidJSON: 'JSON invalido',
              inputLabel: 'Ajustes de Marketplace',
              inputPlaceholder: 'Copia/pega tus ajustes aqui',
              exportBtn: 'Exportar',
              importBtn: 'Importar',
              fileImportBtn: 'Importar desde un archivo',
            },
            devTools: {
              title: 'Herramientas de desarrollador de temas',
              noThemeInstalled: 'Error: No tema de marketplace instalado',
              noThemeManifest: 'Error: No manifiesto de tema encontrado',
              colorIniEditor: 'Editor de Color.ini',
              colorIniEditorPlaceholder: '[nombre-de-esquema-de-color]',
              invalidCSS: 'CSS invalido',
            },
            grid: {
              spicetifyMarketplace: 'Marketplace de Spicetify',
              newUpdate: 'Nueva actualización',
              addCSS: 'Añadir CSS',
              search: 'Buscar',
              installed: 'Instalado',
              lastUpdated: 'Ultima actualización {{val, datetime}}',
              externalJS: 'JS external',
              dark: 'oscuro',
              light: 'claro',
            },
            readmePage: {
              title: '$t(grid.spicetifyMarketplace) - Readme',
              loading: 'Cargando...',
              errorLoading: 'Error cargando README',
            },
            github: 'GitHub',
            install: 'Instalar',
            remove: 'Borrar',
            save: 'Guardar',
            colour_one: 'color',
            colour_other: 'colores',
            favourite: 'favorito',
          },
        },
        fr: {
          translation: {
            settings: {
              title: 'Réglages Marché Spicetify',
              optionsHeading: 'Options',
              starCountLabel: 'Nombres d’étoiles',
              tagsLabel: 'Tags',
              devToolsLabel: 'Outils pour les développeurs de thèmes',
              hideInstalledLabel: 'Masquer ceux étant installés lors de la navigation',
              colourShiftLabel: 'Changer de couleur chaque minutes',
              albumArtBasedColors: "Changement des couleurs basé sur les pochettes d'albums",
              albumArtBasedColorsMode: 'Mode de schéma de couleur (ColorApi)',
              albumArtBasedColorsVibrancy: "Couleur saisie depuis les pochettes d'albums",
              albumArtBasedColorsVibrancyToolTip:
                "Désaturé: La couleur qui est la plus proéminente mais avec beaucoup moins de luminosité\nVibrations Claires: La couleur la plus vibrante, mais avec une luminosité un peu plus forte\nPrometteur: La couleur qui ressort le plus dans la pochette de l'album\nVibrations: La couleur la plus vibrante dans la pochette de l'album",
              albumArtColorsModeToolTip:
                "Monochrome foncé: une palette de couleurs basée directement sur la couleur principale sélectionnée, en utilisant différentes nuances de la couleur principale et en mélangeant des gris pour créer une palette de couleurs, c'est l'inverse du monochrome clair.\nMonochrome clair: Une palette de couleurs basée directement sur la couleur principale sélectionnée, en utilisant différentes nuances de la couleur principale et en mélangeant les gris pour créer une palette de couleurs. L'arrière-plan d'un monochrome clair sera le premier plan ou la couleur du texte d'un monochrome foncé et vice versa.\nAnalogique: Schéma de couleurs basé sur la couleur principale sélectionnée, utilisant les couleurs adjacentes à la couleur principale sur le cercle chromatique.\nAnalogique complémentaire: Un schéma de couleurs basé sur la couleur principale sélectionnée, utilisant les couleurs adjacentes à la couleur principale sur le cercle chromatique et la couleur complémentaire.\nTriade: Un schéma de couleurs basé sur la couleur principale sélectionnée, utilisant les couleurs équidistantes de la couleur principale sur le cercle chromatique.\nQuad: Un schéma de couleurs basé sur la couleur principale sélectionnée, utilisant les couleurs du cercle chromatique qui sont à 90 degrés de la couleur principale.",
              tabsHeading: 'Onglets',
              resetHeading: 'Réinitialiser',
              resetBtn: '$t(settings.resetHeading)',
              resetDescription:
                'Désinstaller toutes les extensions et tous les thèmes, ainsi que l’ensemble des réglages',
              backupHeading: 'Sauvegarde/Restauration',
              backupLabel:
                "Sauvegarder ou restaurer toutes les données du Marché. Celà n'inclue pas les réglages pour quoi que ce soit installé depuis le Marché.",
              backupBtn: 'Ouvrir',
              versionHeading: 'Version',
              versionBtn: 'Copier',
              versionCopied: 'Copié',
            },
            tabs: {
              Extensions: 'Extensions',
              Themes: 'Thèmes',
              Snippets: 'Bribes',
              Apps: 'Applications',
              Installed: 'Installé(s)',
            },
            snippets: {
              addTitle: 'Ajouter Bribe',
              editTitle: 'Éditer Bribe',
              viewTitle: 'Voir Bribe',
              customCSS: 'CSS personnalisé',
              customCSSPlaceholder:
                'Insérez votre propre CSS personnalisé ici! Vous pouvez les retrouver dans l’onglet Installé pour les gérer.',
              snippetName: 'Nom de la bribe',
              snippetNamePlaceholder: 'Entrer un nom pour votre bribe personnalisée',
              snippetDesc: 'Description de la bribe',
              snippetDescPlaceholder: 'Entrez une description pour votre bribe personnalisée',
              snippetPreview: 'Prévisualiser la bribe',
              optional: 'Optionnel',
              addImage: 'Ajouter une image',
              changeImage: 'Changer l’image',
              saveCSS: 'Enregistrer le CSS',
            },
            reloadModal: {
              title: 'Recharger',
              description: 'Un rechargement de la page est requis pour finaliser cette opération.',
              reloadNow: 'Recharger maintenant',
              reloadLater: 'Recharger plus tard',
            },
            backupModal: {
              title: 'Sauvegarder/Restaurer',
              settingsCopied: 'Réglages copiés dans le presse-papier',
              noDataPasted: 'Aucune donnée collée',
              invalidJSON: 'JSON invalide',
              inputLabel: 'Réglages du Marché',
              inputPlaceholder: 'Copier/coller vos réglages ici',
              exportBtn: 'Exporter',
              importBtn: 'Importer',
              fileImportBtn: 'Importer depuis un fichier',
            },
            devTools: {
              title: 'Outils de développeurs de thèmes',
              noThemeInstalled: 'Erreur: Aucun thème du marché n’est installé',
              noThemeManifest: 'Erreur: Aucun manifeste de thème trouvé',
              colorIniEditor: 'Éditeur Color.ini',
              colorIniEditorPlaceholder: '[nom-de-votre-schéma-de-couleur]',
              invalidCSS: 'CSS invalide',
            },
            grid: {
              spicetifyMarketplace: 'Marché Spicetify',
              newUpdate: 'Nouvelle mise à jour',
              addCSS: 'Ajouter CSS',
              search: 'Rechercher',
              installed: 'Installé',
              lastUpdated: 'Dernière mise à jour {{val, datetime}}',
              externalJS: 'JS externe',
              dark: 'sombre',
              light: 'clair',
              sort: {
                label: 'Trier par:',
                stars: 'Étoiles',
                newest: 'Nouveauté',
                oldest: 'Ancienneté',
                lastUpdated: 'Dernière mise à jour',
                mostStale: 'Le plus périmé',
                aToZ: 'A-Z',
                zToA: 'Z-A',
              },
            },
            readmePage: {
              title: '$t(grid.spicetifyMarketplace) - Readme',
              loading: 'Chargement…',
              errorLoading: 'Erreur lors du chargement du README',
            },
            github: 'GitHub',
            install: 'Installer',
            remove: 'Supprimer',
            save: 'Enregistrer',
            colour_one: 'couleur',
            colour_other: 'couleurs',
            favourite: 'favoris',
          },
        },
        ru: {
          translation: {
            settings: {
              title: 'Настройки',
              optionsHeading: 'Основные',
              starCountLabel: 'Отображать количество звезд',
              tagsLabel: 'Отображать теги',
              showArchived: 'Отображать архивные репозитории',
              devToolsLabel: 'Включить инструменты разработчика тем',
              hideInstalledLabel: 'Скрывать установленное в других вкладках',
              colourShiftLabel: 'Менять цвета каждую минуту',
              albumArtBasedColors: 'Использовать цвета на основе обложки альбома',
              albumArtBasedColorsMode: 'Тип цвета',
              albumArtBasedColorsVibrancy: 'Тип цветовой схемы на основе обложки альбома',
              albumArtBasedColorsVibrancyToolTip:
                'Desaturated: наиболее часто встречаемый в обложке цвет с малой яркостью \n Light Vibrant: самый насыщенный цвет с повышенной яркостью \n Prominent: наиболее часто встречаемый цвет в обложке альбома \n Vibrant: самый насыщенный цвет в обложке альбома',
              almbumArtColorsModeToolTip:
                'Monochrome Dark, Monochrome Light: основаны иcключительно на выбранном цвете, дополнительные цвета создаются путем изменения яркости основого. Противоположны друг другу: цвет, являющийся фоновым в Monochrome Light, в Monochrome Dark будет цветом переднего плана и наоборот. \n Analogic: палитра определяется выбранным и цветами, смежными с ним на цветовом круге. \n Analogic Complementary: схожа c Analogic, но сожержит также дополнительный цвет. \n Triad: палитра определяется основным цветом и цветами, равноудаленными от него. \n Quad: палитра определяется выбранным цветом и цветами, расположенных под углом 90 градусов к нему.',
              tabsHeading: 'Вкладки',
              resetHeading: 'Сброс',
              resetBtn: 'Сбросить',
              resetDescription: 'Удалить все и сбросить настройки',
              backupHeading: 'Резервное копирование и восстановление',
              backupLabel:
                'Сохранить или восстановить все данные Маркетплейса, за исключением настроек установленных тем и расширений.',
              backupBtn: 'Открыть',
              versionHeading: 'Версия',
              versionBtn: 'Копировать',
              versionCopied: 'Скопировано',
            },
            tabs: {
              Extensions: 'Расширения',
              Themes: 'Темы',
              Snippets: 'Сниппеты',
              Apps: 'Приложения',
              Installed: 'Установленное',
            },
            snippets: {
              addTitle: 'Добавление сниппета',
              duplicateName: 'Сниппет с таким названием уже существует',
              editTitle: 'Редактирование сниппета',
              viewTitle: 'Просмотр сниппета',
              customCSS: 'CSS',
              customCSSPlaceholder: 'Вставьте сюда CSS вашего сниппета',
              snippetName: 'Название',
              snippetNamePlaceholder: 'Введите название для вашего сниппета',
              snippetDesc: 'Описание',
              snippetDescPlaceholder: 'Введите описание для вашего сниппета',
              snippetPreview: 'Превью',
              optional: 'необязательно',
              addImage: 'Добавить изображение',
              changeImage: 'Изменить изображение',
              saveCSS: 'Сохранить',
            },
            reloadModal: {
              title: 'Перезагрузка',
              description: 'Необходима перезагрузка страницы для применения изменений',
              reloadNow: 'Перезагрузить сейчас',
              reloadLater: 'Перезагрузить позже',
            },
            backupModal: {
              title: '$t(settings.backupHeading)',
              settingsCopied: 'Настройки скопированы в буфер обмена',
              noDataPasted: 'Ничего не вставлено',
              invalidJSON: 'Неверный JSON',
              inputLabel: 'Настройки Маркетплейса',
              inputPlaceholder: 'Вставьте ваши настройки сюда',
              exportBtn: 'Экспортировать',
              importBtn: 'Импортировать',
              fileImportBtn: 'Импортировать из файла',
            },
            devTools: {
              title: 'Инструменты разработчика тем',
              noThemeInstalled: 'Ошибка: Не установлена тема из Маркетплейса',
              noThemeManifest: 'Ошибка: Не найден манифест темы',
              colorIniEditor: 'Редактор color.ini',
              colorIniEditorPlaceholder: '[название-вашей-цветовой-схемы]',
              invalidCSS: 'Неверный CSS',
            },
            updateModal: {
              title: 'Обновление Маркетплейса',
              description: 'Обновите Маркетплейс для получения новых функций и исправлений.',
              currentVersion: 'Текущая версия: {{version}}',
              latestVersion: 'Последняя версия: {{version}}',
              whatsChanged: 'Что нового',
              seeChangelog: 'Посмотреть изменения',
              howToUpgrade: 'Инструкция по обновлению',
              viewGuide: 'Посмотреть инструкцию',
            },
            grid: {
              spicetifyMarketplace: 'Маркетплейс Spicetify',
              newUpdate: 'Доступно обновление',
              addCSS: 'Добавить CSS',
              search: 'Искать',
              installed: 'Установлено',
              lastUpdated: 'Обновлено: {{val, datetime}}',
              externalJS: 'содержит JS',
              archived: 'архивировано',
              dark: 'темный',
              light: 'светлый',
              sort: {
                label: 'Сортировать:',
                stars: 'по количеству звезд',
                newest: 'сначала новые',
                oldest: 'сначала старые',
                lastUpdated: 'сначала недавно обновленные',
                mostStale: 'сначала давно не обновлявшиеся',
                aToZ: 'по названию (A-Z)',
                zToA: 'по названию (Z-A)',
              },
            },
            readmePage: {
              title: '$t(grid.spicetifyMarketplace) - Readme',
              loading: 'Загрузка...',
              errorLoading: 'Ошибка загрузки README',
            },
            github: 'GitHub',
            install: 'Установить',
            remove: 'Удалить',
            save: 'Сохранить',
            colour_one: 'цвет',
            colour_other: 'цвета',
            favourite: 'избранное',
            notifications: {
              wrongLocalTheme:
                "Пожалуйста, измените значение current_theme в config-xpui.ini на 'marketplace', чтобы использовать темы из Маркетплейса",
              tooManyRequests: 'Слишком много запросов. Пожалуйста, попробуйте позже',
              noCdnConnection: 'Маркетплейс не может подключиться к CDN. Пожалуйста, попробуйте позже',
              markdownParsingError: 'Ошибка при парсинге Markdown (HTTP {{status}})',
              noReadmeFile: 'README не найден',
              themeInstallationError: 'Ошибка при установке темы',
              extensionInstallationError: 'Ошибка при установке расширения',
            },
          },
        },
        'zh-TW': {
          translation: {
            settings: {
              title: '設定',
              optionsHeading: '選項',
              starCountLabel: '收藏數',
              tagsLabel: '標籤',
              devToolsLabel: '主題開發者工具',
              hideInstalledLabel: '瀏覽時隱藏已安裝項目',
              colourShiftLabel: '每分鐘進行色調偏移',
              tabsHeading: '分頁',
              resetHeading: '重設',
              resetBtn: '$t(settings.resetHeading)',
              resetDescription: '解除安裝所有擴充套件和主題， 並重設偏好設定',
              backupHeading: '備份與還原',
              backupLabel: '備份或還原所有 Marketplace 中的資料（不包含從 Marketplace 安裝的擴充元件的設定）。',
              backupBtn: '開啟',
              albumArtBasedColors: '根據專輯封面選色',
              albumArtBasedColorsMode: '色彩方案 (ColorApi) 模式',
              albumArtBasedColorsVibrancy: '已從專輯封面抽取顏色',
              albumArtBasedColorsVibrancyToolTip:
                'Desaturated：最突出但亮度較低的顏色 \n Light Vibrant：最接近 Vibrant 的色彩，但亮度稍微提升一些 \n Prominent：專輯封面裡面出現最多的色彩 \n Vibrant：專輯中最明亮的色彩',
              almbumArtColorsModeToolTip:
                'Monochrome Dark：這個色彩方案直接以選擇的主色彩為基礎，但使用比較不一樣的色調並且融入灰色。這和 Monochrome Light 正好相反。 \n Monochrome Light：這個色彩方案直接以選擇的主色彩為基礎，但使用比較不一樣的色調並且融入灰色。這和 Monochrome Light 正好相反。Monochrome Light 的背景色會是 Monochrome Dark 的前景或文字顏色，反之亦然。 \n Analogic：這個色彩方案以選擇的主色彩為基礎，使用色環上主色彩鄰近的色彩。 \n Analogic Complementary：這個色彩方案以選擇的主色彩為基礎，使用色環上主色彩鄰近的色彩以及互補色。 \n Triad：這個色彩方案以選擇的主色彩為基礎，使用色環上和主色彩距離相等的顏色。 \n Quad：這個色彩方案以選擇的主色彩為基礎，使用色環上和主色彩差 90 度的顏色。',
              versionHeading: '版本',
              versionBtn: '複製',
              versionCopied: '已複製',
            },
            tabs: {
              Extensions: '擴充套件',
              Themes: '主題',
              Snippets: '微調片段',
              Apps: '功能模組',
              Installed: '已安裝項目',
            },
            snippets: {
              addTitle: '加入微調片段',
              editTitle: '編輯微調片段',
              viewTitle: '檢視微調片段',
              customCSS: '自訂 CSS',
              customCSSPlaceholder:
                '這裡可以輸入您的自訂 CSS！您可以在「已安裝項目」分頁中看到這些片段，進而進行管理。',
              snippetName: '微調片段名稱',
              snippetNamePlaceholder: '輸入自訂微調片段的名稱',
              snippetDesc: '微調片段描述',
              snippetDescPlaceholder: '輸入自訂微調片段的描述',
              snippetPreview: '微調片段預覽圖',
              optional: '非必須',
              addImage: '加入影像',
              changeImage: '更改影像',
              saveCSS: '儲存 CSS',
            },
            reloadModal: {
              title: '重新載入',
              description: '需要重新載入頁面，才能完成這個操作。',
              reloadNow: '立即重新載入',
              reloadLater: '稍後重新載入',
            },
            backupModal: {
              title: '$t(settings.backupHeading)',
              settingsCopied: '已將設定複製至剪貼簿',
              noDataPasted: '沒有貼上資料',
              invalidJSON: 'JSON 無效',
              inputLabel: 'Marketplace 設定',
              inputPlaceholder: '在此複製或貼上設定',
              exportBtn: '匯出',
              importBtn: '匯入',
              fileImportBtn: '從檔案匯入',
            },
            devTools: {
              title: '主題開發者工具',
              noThemeInstalled: '錯誤：沒有安裝 Marketplace 主題',
              noThemeManifest: '錯誤：找不到主題資訊清單',
              colorIniEditor: 'Color.ini 編輯器',
              colorIniEditorPlaceholder: '[您的色彩配置名稱]',
              invalidCSS: 'CSS 無效',
            },
            grid: {
              spicetifyMarketplace: 'Spicetify Marketplace',
              newUpdate: '有更新',
              addCSS: '加入 CSS',
              search: '搜尋',
              installed: '已經安裝',
              lastUpdated: '上次更新於 {{val, datetime}}',
              externalJS: '有外部 JS',
              dark: '暗色',
              light: '亮色',
            },
            readmePage: {
              title: '$t(grid.spicetifyMarketplace) – 說明',
              loading: '正在載入……',
              errorLoading: '載入 README 時發生錯誤',
            },
            github: 'GitHub',
            install: '安裝',
            remove: '移除',
            save: '儲存',
            colour_one: '色彩',
            colour_other: '色彩',
            favourite: '收藏',
          },
        },
        'zh-CN': {
          translation: {
            settings: {
              title: '设置',
              optionsHeading: '选项',
              starCountLabel: '收藏数',
              tagsLabel: '标签',
              devToolsLabel: '主題开发者工具',
              hideInstalledLabel: '浏览时隐藏已安装项目',
              colourShiftLabel: '每分钟进行色调偏移',
              tabsHeading: '分页',
              resetHeading: '重置',
              resetBtn: '$t(settings.resetHeading)',
              resetDescription: '卸载所有扩展插件和主题，并重置设置',
            },
            tabs: {
              Extensions: '扩展插件',
              Themes: '主题',
              Snippets: '微调片段',
              Apps: '功能模组',
              Installed: '已安裝项目',
            },
            snippets: {
              addTitle: '加入微调片段',
              editTitle: '编辑微调片段',
              viewTitle: '检视微调片段',
              customCSS: '自定义 CSS',
              customCSSPlaceholder:
                '这里可以输入您的自定义 CSS！您可以在「已安裝项目」标签页中看到这些片段，进而进行管理。',
              snippetName: '微调片段名称',
              snippetNamePlaceholder: '输入自定义微调片段的名称',
              snippetDesc: '微调片段描述',
              snippetDescPlaceholder: '输入自定义微调片段的描述',
              snippetPreview: '微调片段预览图',
              optional: '非必要',
              addImage: '加入影像',
              changeImage: '更改影像',
              saveCSS: '保存 CSS',
            },
            reloadModal: {
              title: '重新加载',
              description: '需要重新加载页面，才能完成这个操作。',
              reloadNow: '立即重新加载',
              reloadLater: '稍后重新加载',
            },
            devTools: {
              title: '主題开发者工具',
              noThemeInstalled: '错误：未安装商场主题',
              noThemeManifest: '错误：找不到主题内容清单',
              colorIniEditor: 'Color.ini 编辑器',
              colorIniEditorPlaceholder: '[您的色彩配置名称]',
              invalidCSS: 'CSS 无效',
            },
            grid: {
              spicetifyMarketplace: 'Spicetify 商场',
              newUpdate: '有更新',
              addCSS: '加入 CSS',
              search: '搜索',
              installed: '已安装',
              lastUpdated: '上次更新于 {{val, datetime}}',
              externalJS: '有外部 JS',
              dark: '暗色模式',
              light: '亮色模式',
            },
            readmePage: {
              title: '$t(grid.spicetifyMarketplace) – 说明',
              loading: '正在加载……',
              errorLoading: '加载 README 时发生错误',
            },
            github: 'GitHub',
            install: '安裝',
            remove: '移除',
            save: '保存',
            colour_one: '色彩',
            colour_other: '色彩',
            favourite: '收藏',
          },
        },
        et: {
          translation: {
            settings: {
              title: 'Turu seaded',
              optionsHeading: 'Seaded',
              starCountLabel: 'Tähtede arv',
              tagsLabel: 'Sildid',
              devToolsLabel: 'Teema arendaja tööriistad',
              hideInstalledLabel: 'Peida sirvimisel paigaldatud',
              colourShiftLabel: 'Muutke värve iga minut',
              albumArtBasedColors: 'Muutke värve albumipildi põhjal',
              albumArtBasedColorsMode: 'Värviskeemi (ColorApi) režiim',
              albumArtBasedColorsVibrancy: 'Albumipildilt haaratud värv',
              albumArtBasedColorsVibrancyToolTip:
                'Desaturated: Värv, mis on kõige silmatorkavam, kuid palju väiksema heledusega \n Light vibrant: Kõige erksam värv, kuid veidi suurendatud heledusega \n Prominent: Värv, mis ilmub albumi kujunduses kõige rohkem \n Vibrant: Albumipildi kõige elavam värv',
              almbumArtColorsModeToolTip:
                'Monochrome dark: Värvilahendus, mis põhineb otse valitud põhivärvil, kasutades põhivärvi erinevaid toone ja segades värviskeemi loomiseks halle, see on ühevärvlise heleda pöördväärtus. \n Monochrome light: Värvilahendus, mis põhineb otse valitud põhivärvil, kasutades põhivärvi erinevaid toone ja segades värviskeemi loomiseks halle. Ühevärvilise valguse taust oleks ühevärvilise tumeda esiplaani või teksti värv ja vastupidi. \n Analogic: Valitud põhivärvil põhinev värviskeem, kasutades värviratta põhivärviga külgnevaid värve. \n Analogic complement: Valitud põhivärvil põhinev värviskeem, kasutades värviratta põhivärviga külgnevaid värve ja lisavärvi. \n Triad: Valitud põhivärvil põhinev värviskeem, kasutades põhivärvist võrdsel kaugusel asuvaid värviratta värve. \n Quad: Valitud põhivärvil põhinev värviskeem, kasutades värvirattal olevaid värve, mis on põhivärvist 90 kraadi.',
              tabsHeading: 'Vahekaardid',
              resetHeading: 'Reset',
              resetBtn: '$t(settings.resetHeading)',
              resetDescription: 'Uninstall all extensions and themes, and reset preferences',
              backupHeading: 'Varunda/Taasta',
              backupLabel:
                'Varunda või taasta kõik turu andmed. See ei hõlma turu kaudu paigaldatud elementide seadeid.',
              backupBtn: 'Ava',
              versionHeading: 'Versioon',
              versionBtn: 'Kopeeri',
              versionCopied: 'Kopeeritud',
            },
            tabs: {
              Extensions: 'Lisad',
              Themes: 'Teemad',
              Snippets: 'Katked',
              Apps: 'Rakendused',
              Installed: 'Paigaldatud',
            },
            snippets: {
              addTitle: 'Lisa katkend',
              editTitle: 'Muuda katkendit',
              viewTitle: 'Vaata katkendit',
              customCSS: 'Kohandatud CSS',
              customCSSPlaceholder: 'Paigalda Kohandatud CSS siia! Haldamiseks leiate need paigaldatud vahekaardilt.',
              snippetName: 'Katkendi nimi',
              snippetNamePlaceholder: 'Lisa kohandatud katkendi nimi',
              snippetDesc: 'Katkendi kirjeldus',
              snippetDescPlaceholder: 'Lisa kohandatud katkendi kirjeldus',
              snippetPreview: 'Katkendi eelvaade',
              optional: 'valikuline',
              addImage: 'Lisa pilt',
              changeImage: 'Muuda pilti',
              saveCSS: 'Salvesta CSS',
            },
            reloadModal: {
              title: 'Laadi uuesti',
              description: 'Selle toimingu lõpuleviimiseks on vaja leht uuesti laadida.',
              reloadNow: 'Laadige kohe uuesti',
              reloadLater: 'Laadige hiljem uuesti',
            },
            backupModal: {
              title: '$t(settings.backupHeading)',
              settingsCopied: 'Seaded kopeeriti lõikelauale',
              noDataPasted: 'Andmeid pole kleebitud',
              invalidJSON: 'Vale JSON',
              inputLabel: 'Turu Seaded',
              inputPlaceholder: 'Kopeeri/kleebi enda seaded siia',
              exportBtn: 'Ekspordi',
              importBtn: 'Impordi',
              fileImportBtn: 'Impordi failist',
            },
            devTools: {
              title: 'Teema arendustööriistad',
              noThemeInstalled: 'Viga: Turu teemat pole installitud',
              noThemeManifest: 'Viga: Teema manifesti ei leitud',
              colorIniEditor: 'Color.ini redaktor',
              colorIniEditorPlaceholder: '[teie-värviskeemi-nimi]',
              invalidCSS: 'Vigane CSS',
            },
            grid: {
              spicetifyMarketplace: 'Spicetify Turg',
              newUpdate: 'Uus värskendus',
              addCSS: 'Lisa CSS',
              search: 'Otsi',
              installed: 'Paigaldatud',
              lastUpdated: 'Viimati uuendatud {{val, datetime}}',
              externalJS: 'väline JS',
              dark: 'tume',
              light: 'hele',
            },
            readmePage: {
              title: '$t(grid.spicetifyMarketplace) - Readme',
              loading: 'Laadimine...',
              errorLoading: 'Viga README laadimisel',
            },
            github: 'GitHub',
            install: 'Paigalda',
            remove: 'Eemalda',
            save: 'Salvesta',
            colour_one: 'värv',
            colour_other: 'värvid',
            favourite: 'lemmik',
          },
        },
        pl: {
          translation: {
            settings: {
              title: 'Ustawienia Marketplace',
              optionsHeading: 'Opcje',
              starCountLabel: 'Ilość gwiazdek',
              tagsLabel: 'Tagi',
              showArchived: 'Pokaż archiwalne repozytoria',
              devToolsLabel: 'Narzędzia do tworzenia motywów',
              hideInstalledLabel: 'Ukryj zainstalowane podczas przeglądania',
              colourShiftLabel: 'Zmieniaj kolory co minutę',
              albumArtBasedColors: 'Zmień kolory bazując na okładce albumu',
              albumArtBasedColorsMode: 'Tryb schematu kolorów (ColorApi)',
              albumArtBasedColorsVibrancy: 'Kolor pobrany z okładki albumu',
              albumArtBasedColorsVibrancyToolTip:
                'Nasycony: Kolor, który jest najbardziej widoczny, ale o znacznie mniejszej jasności. \nJasny wibrujący: Najbardziej żywy kolor, ale z nieco zwiększoną jasnością. \nWyraźny: Kolor, który najbardziej rzuca się w oczy na okładce albumu. \nWibrujący: Najbardziej żywy kolor na okładce albumu',
              almbumArtColorsModeToolTip:
                'Monochromatyczny ciemny: Schemat kolorów oparty bezpośrednio na wybranym głównym kolorze, wykorzystujący różne odcienie głównego koloru i mieszający szarości w celu stworzenia schematu kolorów, jest to odwrotność Monochromatycznego jasnego. \nMonochromatyczny jasny: Schemat kolorów oparty bezpośrednio na wybranym głównym kolorze, wykorzystujący różne odcienie głównego koloru i mieszanie szarości w celu utworzenia schematu kolorów. Tło monochromatycznego światła będzie na pierwszym planie lub kolorem tekstu w monochromatycznym ciemnym i odwrotnie. \nAnalogowy: Schemat kolorów oparty na wybranym głównym kolorze, wykorzystujący kolory sąsiadujące z głównym kolorem na kole kolorów. \nUzupełnienie analogowe: Schemat kolorów oparty na wybranym głównym kolorze, wykorzystujący kolory sąsiadujące z głównym kolorem na kole kolorów i kolorem uzupełniającym. \nTriada: Schemat kolorów oparty na wybranym głównym kolorze, wykorzystujący kolory na kole kolorów, które są w równej odległości od głównego koloru. \nQuad: Schemat kolorów oparty na wybranym głównym kolorze, wykorzystujący kolory na kole kolorów, które są oddalone o 90 stopni od głównego koloru.',
              tabsHeading: 'Karty',
              resetHeading: 'Reset',
              resetBtn: 'Zresetuj',
              resetDescription: 'Odinstaluj wszystkie rozszerzenia, motywy i zresetuj preferencje',
              backupHeading: 'Kopia zapasowa/Przywracanie kopii',
              backupLabel:
                'Utwórz kopię zapasową lub przywróć wszystkie dane Marketplace. Kopia nie zawiera ustawień dla rzeczy zainstalowanych poprzez Marketplace.',
              backupBtn: 'Otwórz',
              versionHeading: 'Wersja',
              versionBtn: 'Skopiuj',
              versionCopied: 'Skopiowano',
            },
            tabs: {
              Extensions: 'Rozszerzenia',
              Themes: 'Motywy',
              Snippets: 'Snippety',
              Apps: 'Aplikacje',
              Installed: 'Zainstalowane',
            },
            snippets: {
              addTitle: 'Dodaj Snippet',
              duplicateName: 'Ta nazwa jest już zajęta!',
              editTitle: 'Edytuj Snippet',
              viewTitle: 'Pokaż Snippet',
              customCSS: 'Niestandardowy CSS',
              customCSSPlaceholder:
                "Wprowadź tutaj swój własny CSS! Możesz go znaleźć w zakładce 'Zainstalowane' aby nim zarządzać.",
              snippetName: 'Nazwa snippetu',
              snippetNamePlaceholder: 'Wprowadź nazwę swojego niestandardowego snippetu',
              snippetDesc: 'Opis snippetu',
              snippetDescPlaceholder: 'Wpisz opis swojego snippetu',
              snippetPreview: 'Podgląd snippetu',
              optional: 'Opcjonalne',
              addImage: 'Dodaj obraz',
              changeImage: 'Zmień obraz',
              saveCSS: 'Zapisz CSS',
            },
            reloadModal: {
              title: 'Przeładuj',
              description: 'Do ukończenia tej operacji wymagane jest przeładowanie strony.',
              reloadNow: 'Przeładuj teraz',
              reloadLater: 'Przeładuj póżniej',
            },
            backupModal: {
              title: '$t(settings.backupHeading)',
              settingsCopied: 'Skopiowano do schowka',
              noDataPasted: 'Dane nie zostały wklejone',
              invalidJSON: 'Nieprawidłowy JSON',
              inputLabel: 'Ustawienia Marketplace',
              inputPlaceholder: 'Skopiuj/wklej tu swoje ustawienia',
              exportBtn: 'Eksportuj',
              importBtn: 'Importuj',
              fileImportBtn: 'Importuj z pliku',
            },
            devTools: {
              title: 'Narzędzia developerskie do motywów',
              noThemeInstalled: 'Błąd: Nie zainstalowano motywu',
              noThemeManifest: 'Błąd: Nie znaleziono pliku manifestu motywu',
              colorIniEditor: 'Edytor color.ini',
              colorIniEditorPlaceholder: '[nazwa-twojego-koloru]',
              invalidCSS: 'Nieprawidłowy CSS',
            },
            updateModal: {
              title: 'Zaktualizuj Marketplace',
              description: 'Zaktualizuj Spicetify Marketplace, aby otrzymywać nowe funkcje i poprawki błędów.',
              currentVersion: 'Obecna wersja: {{version}}',
              latestVersion: 'Najnowsza wersja: {{version}}',
              whatsChanged: 'Co się zmieniło',
              seeChangelog: 'Zobacz zmiany',
              howToUpgrade: 'Jak zaktualizować',
              viewGuide: 'Zobacz przewodnik',
            },
            grid: {
              spicetifyMarketplace: 'Spicetify Marketplace',
              newUpdate: 'Nowa aktualizacja',
              addCSS: 'Dodaj CSS',
              search: 'Wyszukaj',
              installed: 'Zainstalowane',
              lastUpdated: 'Ostatnio zaktualizowane {{val, datetime}}',
              externalJS: 'zewnętrzny JS',
              archived: 'archiwalny',
              dark: 'ciemny',
              light: 'jasny',
              sort: {
                label: 'Sortuj po:',
                stars: 'Ilość gwiazdek',
                newest: 'Najnowsze',
                oldest: 'Najstarsze',
                lastUpdated: 'Ostatnio zaktualizowane',
                mostStale: 'Najrzadziej aktualizowane',
                aToZ: 'A-Z',
                zToA: 'Z-A',
              },
            },
            readmePage: {
              title: '$t(grid.spicetifyMarketplace) - Readme',
              loading: 'Ładowanie...',
              errorLoading: 'Błąd podczas ładowania README',
            },
            github: 'GitHub',
            install: 'Zainstaluj',
            remove: 'Odinstaluj',
            save: 'Zapisz',
            colour_one: 'kolor',
            colour_other: 'kolory',
            favourite: 'ulubione',
            notifications: {
              wrongLocalTheme:
                'Ustaw current_theme w config-xpui.ini na "marketplace", aby instalować motywy za pomocą Marketplace.',
              tooManyRequests: 'Za dużo żądań, spokojnie',
              noCdnConnection: 'Marketplace nie może połączyć się z CDN. Sprawdź swoją konfigurację internetową',
              markdownParsingError: 'Błąd podczas parsowania markdownu (HTTP {{status}})',
              noReadmeFile: 'Nie znaleziono README',
              themeInstallationError: 'Wystąpił błąd podczas instalacji motywu',
              extensionInstallationError: 'Wystąpił błąd podczas instalacji rozszerzenia',
            },
          },
        },
        it: {
          translation: {
            settings: {
              title: 'Impostazioni Marketplace',
              optionsHeading: 'Opzioni',
              starCountLabel: 'Contatore stelle',
              tagsLabel: 'Tag',
              showArchived: 'Mostra repository archiviati',
              devToolsLabel: 'Strumenti di sviluppo del tema',
              hideInstalledLabel: 'Nascondi i pacchetti già installati durante la navigazione',
              colourShiftLabel: 'Cambia colori ogni minuto',
              albumArtBasedColors: "Cambia i colori in base alla copertina dell'album",
              albumArtBasedColorsMode: 'Schema colori modalità (ColorApi)',
              albumArtBasedColorsVibrancy: "Colore preso dalla copertina dell'album",
              albumArtBasedColorsVibrancyToolTip:
                "Desaturato: Il colore predominante ma con molta meno luminosità \n Vibrante Chiaro: Il colore più intenso ma con la luminosità aumentata leggermente \n Predominante: Il colore che spicca di più nella copertina dell'album \n Vibrante: Il colore più intenso nella copertina dell'album",
              almbumArtColorsModeToolTip:
                "Monocromo Scuro: Uno schema di colori basato direttamente sul colore principale selezionato, utilizzando diverse sfumature del colore principale e mescolando i grigi per creare uno schema di colori; questo è l'inverso di Monocromo Chiaro. \n Monocromo Chiaro: Uno schema di colori basato direttamente sul colore principale selezionato, utilizzando diverse sfumature del colore principale e mescolando i grigi per creare uno schema di colori. Lo sfondo di Monocromo Chiaro sarebbe il colore del testo o di quello in primo piano su Monocromo Scuro e viceversa. \n Armonico: Uno schema di colori basato sul colore principale selezionato, utilizzando i colori adiacenti al colore principale sulla ruota dei colori.\n Armonico Complementare: Uno schema di colori basato sul colore principale selezionato, utilizzando i colori adiacenti al colore principale sulla ruota dei colori e il colore complementare. \n Ternario: Uno schema di colori basato sul colore principale selezionato, utilizzando i colori sulla ruota dei colori che sono equidistanti dal colore principale. \n Quaternario: Uno schema di colori basato sul colore principale selezionato, utilizzando i colori sulla ruota dei colori che sono a 90 gradi dal colore principale.",
              tabsHeading: 'Schede',
              resetHeading: 'Reimposta',
              resetBtn: '$t(settings.resetHeading)',
              resetDescription: 'Disinstalla tutte le estensioni e i temi, e ripristina le preferenze',
              backupHeading: 'Backup/Ripristino',
              backupLabel:
                'Effettua il backup o ripristina tutti i dati del Marketplace. Questo non include le impostazioni per qualsiasi elemento installato tramite Marketplace.',
              backupBtn: 'Apri',
              versionHeading: 'Versione',
              versionBtn: 'Copia',
              versionCopied: 'Copiato',
            },
            tabs: {
              Extensions: 'Estensioni',
              Themes: 'Temi',
              Snippets: 'Moduli',
              Apps: 'Applicazioni',
              Installed: 'Installato',
            },
            snippets: {
              addTitle: 'Aggiungi Modulo',
              duplicateName: 'Questo nome è già stato utilizzato!',
              editTitle: 'Modifica Modulo',
              viewTitle: 'Visualizza Modulo',
              customCSS: 'CSS personalizzato',
              customCSSPlaceholder:
                'Scrivi qui il tuo CSS personalizzato! Puoi trovarli nella scheda degli installati per la gestione.',
              snippetName: 'Nome Modulo',
              snippetNamePlaceholder: 'Inserisci un nome per il tuo modulo personalizzato',
              snippetDesc: 'Descrizione Modulo',
              snippetDescPlaceholder: 'Inserisci una descrizione per il tuo modulo personalizzato',
              snippetPreview: 'Anteprima Modulo',
              optional: 'Opzionale',
              addImage: 'Aggiungi immagine',
              changeImage: 'Cambia immagine',
              saveCSS: 'Salva CSS',
            },
            reloadModal: {
              title: 'Ricarica',
              description: 'È necessario ricaricare la pagina per completare questa operazione.',
              reloadNow: 'Ricarica',
              reloadLater: 'Più tardi',
            },
            backupModal: {
              title: '$t(settings.backupHeading)',
              settingsCopied: 'Impostazioni copiate negli appunti',
              noDataPasted: 'Nessun dato incollato',
              invalidJSON: 'JSON non valido',
              inputLabel: 'Impostazioni Marketplace',
              inputPlaceholder: 'Copia/incolla qui le tue impostazioni',
              exportBtn: 'Esporta',
              importBtn: 'Importa',
              fileImportBtn: 'Importa da file',
            },
            devTools: {
              title: 'Strumenti di sviluppo del tema',
              noThemeInstalled: 'Errore: Nessun tema del Marketplace installato',
              noThemeManifest: 'Errore: Nessun manifest del tema trovato',
              colorIniEditor: 'Editor Color.ini',
              colorIniEditorPlaceholder: '[nome-del-tuo-schema-colori]',
              invalidCSS: 'Classi CSS non valide',
            },
            updateModal: {
              title: 'Aggiorna il Marketplace',
              description: 'Aggiorna Spicetify Marketplace per ricevere nuove funzionalità e correzioni dei bug.',
              currentVersion: 'Versione attuale: {{version}}',
              latestVersion: 'Ultima versione: {{version}}',
              whatsChanged: "Cos'è Cambiato",
              seeChangelog: 'Guarda il changelog',
              howToUpgrade: "Come effettuare l'aggiornamento",
              viewGuide: 'Visualizza guida',
            },
            grid: {
              spicetifyMarketplace: 'Spicetify Marketplace',
              newUpdate: 'Nuovo aggiornamento',
              addCSS: 'Aggiungi CSS',
              search: 'Cerca',
              installed: 'Installato',
              lastUpdated: 'Ultimo aggiornamento {{val, datetime}}',
              externalJS: 'jS esterno',
              archived: 'archiviato',
              dark: 'scuro',
              light: 'chiaro',
              sort: {
                label: 'Ordina per:',
                stars: 'Valutazione',
                newest: 'Più recente',
                oldest: 'Meno recenti',
                lastUpdated: 'Ultimo aggiornamento',
                mostStale: 'Meno Aggiornato',
                aToZ: 'A-Z',
                zToA: 'Z-A',
              },
            },
            readmePage: {
              title: '$t(grid.spicetifyMarketplace) - Readme',
              loading: 'Caricamento...',
              errorLoading: 'Errore nel caricamento del README',
            },
            github: 'GitHub',
            install: 'Installa',
            remove: 'Rimuovi',
            save: 'Salva',
            colour_one: 'colore',
            colour_other: 'colori',
            favourite: 'preferito',
            notifications: {
              wrongLocalTheme:
                "Si prega d'impostare current_theme in config-xpui.ini su 'marketplace' per installare temi utilizzando il Marketplace",
              tooManyRequests: 'Troppe richieste, attendi un momento',
              noCdnConnection:
                'Il Marketplace non riesce a connettersi al CDN. Si prega di controllare la configurazione Internet',
              markdownParsingError: "Errore durante l'analisi del Markdown (HTTP {{status}})",
              noReadmeFile: 'Nessun README trovato',
              themeInstallationError: "Si è verificato un errore durante l'installazione del tema",
              extensionInstallationError: "Si è verificato un errore durante l'installazione dell'estensione",
            },
          },
        },
        uk: {
          translation: {
            settings: {
              title: 'Налаштування Маркетплейсу',
              optionsHeading: 'Налаштування',
              starCountLabel: 'Кількість зірок',
              tagsLabel: 'Теги',
              showArchived: 'Показати заархівовані репозиторії',
              devToolsLabel: 'Інструменти розробника тем',
              hideInstalledLabel: 'Сховати встановлені',
              colourShiftLabel: 'Змінювати колір кожну хвилину',
              albumArtBasedColors: 'Змінювати колір в залежності від обкладинки альбому',
              albumArtBasedColorsMode: 'Кольорова схема (ColorApi)',
              albumArtBasedColorsVibrancy: 'Колір взято з обкладинки альбому',
              albumArtBasedColorsVibrancyToolTip:
                'Насичений: Колір, який є найбільш помітним, але з набагато меншою яскравістю \n Light Vibrant (Яскравий): Найяскравіший колір, але з дещо підвищеною яскравістю \n Виразний: Колір, який найбільше виділяється на обкладинці альбому \n Яскравий: Найяскравіший колір на обкладинці альбому',
              almbumArtColorsModeToolTip:
                'Монохромний темний: кольорова схема, що базується безпосередньо на вибраному основному кольорі, з використанням різних відтінків основного кольору та змішуванням сірих кольорів для створення кольорової схеми, це протилежність монохромного світлого. \n Монохромний світлий: Кольорова схема, що базується безпосередньо на вибраному основному кольорі, з використанням різних відтінків основного кольору та змішуванням сірих кольорів для створення кольорової схеми. Тло монохромного світлого буде переднім планом або кольором тексту на монохромному темному, і навпаки. \n Аналоговий: Кольорова схема, заснована на вибраному основному кольорі з використанням кольорів, суміжних з основним кольором на колірному колі. \n Аналогово-доповнювальна: Кольорова схема на основі вибраного основного кольору з використанням сусідніх з ним кольорів на колірному колі та додаткового кольору. \n Тріада: Кольорова схема на основі вибраного основного кольору з використанням кольорів на колі кольорів, рівновіддалених від основного кольору. \n Квадрат: Кольорова схема на основі вибраного основного кольору з використанням кольорів на колі кольорів, розташованих під кутом 90 градусів до основного кольору.',
              tabsHeading: 'Вкладки',
              resetHeading: 'Скинути',
              resetBtn: '$t(settings.resetHeading)',
              resetDescription: 'Видалити усі розширення і теми, та скинути налаштування',
              backupHeading: 'Резервне копіювання/Відновлення',
              backupLabel:
                'Копіювати або відновити всі дані Маркетплейсу. Це не включає в себе налаштування всього, що встановлено через Маркетплейс',
              backupBtn: 'Відкрити',
              versionHeading: 'Версія',
              versionBtn: 'Копіювати',
              versionCopied: 'Скопійовано',
            },
            tabs: {
              Extensions: 'Розширення',
              Themes: 'Теми',
              Snippets: 'Фрагменти',
              Apps: 'Застосунки',
              Installed: 'Встановлено',
            },
            snippets: {
              addTitle: 'Додати фрагмент',
              duplicateName: 'Ця назва вже зайнята!',
              editTitle: 'Редагувати фрагмент',
              viewTitle: 'Переглянути фрагмент',
              customCSS: 'Користувацький CSS',
              customCSSPlaceholder:
                'Введіть свій власний CSS тут! Ви можете знайти їх у вкладці управління встановленими файлами.',
              snippetName: 'Назва фрагменту',
              snippetNamePlaceholder: "Введіть ім'я для вашого користувацького фрагменту",
              snippetDesc: 'Опис фрагменту',
              snippetDescPlaceholder: 'Введіть опис для вашого користувацького фрагменту',
              snippetPreview: 'Перегляд фрагменту',
              optional: "Необов'язковий",
              addImage: 'Додати світлину',
              changeImage: 'Змінити світлину',
              saveCSS: 'Зберегти CSS',
            },
            reloadModal: {
              title: 'Перезавантажити',
              description: 'Для завершення цієї операції потрібно перезавантажити сторінку',
              reloadNow: 'Перезавантажити зараз',
              reloadLater: 'Перезавантажити пізніше',
            },
            backupModal: {
              title: '$t(settings.backupHeading)',
              settingsCopied: 'Налаштування скопійовано у буфер обміну',
              noDataPasted: 'Дані не вставлено',
              invalidJSON: 'Недійсний JSON',
              inputLabel: 'Налаштування Маркетплейсу',
              inputPlaceholder: 'Скопіювати/вставити свої налаштування сюди',
              exportBtn: 'Експорт',
              importBtn: 'Імпорт',
              fileImportBtn: 'Імпортувати з файлу',
            },
            devTools: {
              title: 'Інструменти розробника тем',
              noThemeInstalled: 'Помилка: Тему Маркетплейсу не встановлено',
              noThemeManifest: 'Помилка: маніфест теми не знайдено',
              colorIniEditor: 'Редактор Color.ini',
              colorIniEditorPlaceholder: '[your-colour-scheme-name]',
              invalidCSS: 'Недійсний CSS',
            },
            updateModal: {
              title: 'Оновити Маркетплейс',
              description: 'Оновіть Spicetify Marketplace щоб отримувати нові функції і багфікси.',
              currentVersion: 'Поточна версія: {{version}}',
              latestVersion: 'Остання версія: {{version}}',
              whatsChanged: 'Що змінилося',
              seeChangelog: 'Переглянути список змін',
              howToUpgrade: 'Як оновлюватися',
              viewGuide: 'Переглянути посібник',
            },
            grid: {
              spicetifyMarketplace: 'Маркетплейс Spicetify',
              newUpdate: 'Нове оновлення',
              addCSS: 'Додати CSS',
              search: 'Пошук',
              installed: 'Встановлено',
              lastUpdated: 'Востаннє оновлено {{val, datetime}}',
              externalJS: 'зовнішній JS',
              archived: 'заархівоване',
              dark: 'темний',
              light: 'світлий',
              sort: {
                label: 'Сортувати за:',
                stars: 'Зірки',
                newest: 'Новіші',
                oldest: 'Старіші',
                lastUpdated: 'Останнє оновлене',
                mostStale: 'Найнесвіжіший',
                aToZ: 'A-Z',
                zToA: 'Z-A',
              },
            },
            readmePage: {
              title: '$t(grid.spicetifyMarketplace) - Readme',
              loading: 'Завантаження...',
              errorLoading: 'Помилка завантаження README',
            },
            github: 'GitHub',
            install: 'Встановити',
            remove: 'Видалити',
            save: 'Зберегти',
            colour_one: 'колір',
            colour_other: 'кольори',
            favourite: 'улюблене',
            notifications: {
              wrongLocalTheme:
                "Будь ласка, поставте 'marketplace' у змінну current_theme у файлі config-xpui.ini щоб встановлювати теми за допомогою Маркетплейсу",
              tooManyRequests: 'Забагато запитів, зачекайте',
              noCdnConnection:
                "Маркетплейс не може зв'язатися з CDN. Будь ласка, перевірте вашу конфігурацію Інтернету",
              markdownParsingError: 'Помилка розбору markdown (HTTP {{status}})',
              noReadmeFile: 'README не знайдено',
              themeInstallationError: 'Сталася помилка при встановленні теми',
              extensionInstallationError: 'Сталася помилка при встановленні розширення',
            },
          },
        },
        ja: {
          translation: {
            settings: {
              title: 'マーケットプレイスの設定',
              optionsHeading: 'オプション',
              starCountLabel: 'スターの数',
              tagsLabel: 'タグ',
              showArchived: 'アーカイブされたリポジトリを表示',
              devToolsLabel: 'テーマ開発者ツール',
              hideInstalledLabel: 'ブラウジング時にインストール済みを非表示にする',
              colourShiftLabel: '1分ごとに色を変更',
              albumArtBasedColors: 'アルバムアートに基づいて色を変更',
              albumArtBasedColorsMode: 'カラースキーム（ColorApi）モード',
              albumArtBasedColorsVibrancy: 'アルバムアートから取得した色',
              albumArtBasedColorsVibrancyToolTip:
                'Desaturated: 最も目立つ色だが、明るさがはるかに抑えられています \n Light Vibrant: 最も活気ある色ですが、明るさが少し増しています \n Prominent: アルバムアートで最も目立つ色です \n Vibrant: アルバムアートで最も鮮やかな色です',
              almbumArtColorsModeToolTip:
                'Monochrome Dark: 選択したメインカラーを基にした色の配色スキームで、メインカラーの異なる濃淡やグレーを混ぜて配色することで、これはMonochrome Lightの反対です。 \n Monochrome Light: 選択したメインカラーを直接基にした色の配色スキームで、メインカラーの異なる濃淡やグレーを混ぜて配色します。Monochrome Lightの背景色は、Monochrome Darkの前景色やテキスト色となり、その逆も同様です。 \n Analogic: 選択されたメインカラーを基に、カラーホイール上でメインカラーに隣接する色を使用した配色スキームです。 \n Analogic Complementary: 選択したメインカラーを基に、カラーホイール上でメインカラーに隣接する色と補色を使用した配色スキームです。 \n Triad: 選択したメインカラーを基に、カラーホイール上でメインカラーから等距離にある色を使用した配色スキームです。 \n Quad: 選択されたメインカラーを基に、カラーホイール上でメインカラーから90度離れた色を使用した配色スキームです。',
              tabsHeading: 'タブ',
              resetHeading: 'リセット',
              resetBtn: '$t(settings.resetHeading)',
              resetDescription: 'すべての拡張機能とテーマをアンインストールし、設定をリセットします',
              backupHeading: 'バックアップ/リストア',
              backupLabel:
                'すべてのマーケットプレイスデータのバックアップまたはリストアを行います。これには、マーケットプレイスを介してインストールされた設定は含まれません。',
              backupBtn: '開く',
              versionHeading: 'バージョン',
              versionBtn: 'コピー',
              versionCopied: 'コピーされました',
            },
            tabs: {
              Extensions: '拡張機能',
              Themes: 'テーマ',
              Snippets: 'スニペット',
              Apps: 'アプリ',
              Installed: 'インストール済み',
            },
            snippets: {
              addTitle: 'スニペットを追加',
              duplicateName: 'その名前は既に使われています!',
              editTitle: 'スニペットを編集',
              viewTitle: 'スニペットを表示',
              customCSS: 'カスタムCSS',
              customCSSPlaceholder:
                'ここにカスタムCSSを入力してください! 管理用のインストール済みタブで見つけることができます。',
              snippetName: 'スニペット名',
              snippetNamePlaceholder: 'カスタムスニペットの名前を入力してください',
              snippetDesc: 'スニペットの説明',
              snippetDescPlaceholder: 'カスタムスニペットの説明を入力してください',
              snippetPreview: 'スニペットプレビュー',
              optional: 'オプション',
              addImage: '画像を追加',
              changeImage: '画像を変更',
              saveCSS: 'CSSを保存',
            },
            reloadModal: {
              title: 'リロード',
              description: 'この操作を完了するにはページのリロードが必要です。',
              reloadNow: '今すぐ読み込む',
              reloadLater: '後で読み込む',
            },
            backupModal: {
              title: '$t(settings.backupHeading)',
              settingsCopied: '設定がクリップボードにコピーされました',
              noDataPasted: 'データが貼り付けられていません',
              invalidJSON: '無効なJSON',
              inputLabel: 'マーケットプレイスの設定',
              inputPlaceholder: 'ここに設定をコピー＆ペーストしてください',
              exportBtn: 'エクスポート',
              importBtn: 'インポート',
              fileImportBtn: 'ファイルからインポート',
            },
            devTools: {
              title: 'テーマ開発ツール',
              noThemeInstalled: 'エラー：マーケットプレイスのテーマがインストールされていません',
              noThemeManifest: 'エラー：テーママニフェストが見つかりませんでした',
              colorIniEditor: 'Color.ini Editor',
              colorIniEditorPlaceholder: '[your-colour-scheme-name]',
              invalidCSS: '無効なCSS',
            },
            updateModal: {
              title: 'マーケットプレイスの更新',
              description: '新機能やバグ修正を受け取るために、Spicetify Marketplaceを更新してください。',
              currentVersion: '現在のバージョン: {{version}}',
              latestVersion: '最新のバージョン: {{version}}',
              whatsChanged: '変更内容',
              seeChangelog: '変更履歴を見る',
              howToUpgrade: 'アップグレード方法',
              viewGuide: 'ガイドを見る',
            },
            grid: {
              spicetifyMarketplace: 'Spicetify Marketplace',
              newUpdate: '新しいアップデート',
              addCSS: 'CSSを追加',
              search: '検索',
              installed: 'インストール済み',
              lastUpdated: '{{val, datetime}}に最終更新',
              externalJS: '外部JS',
              archived: 'アーカイブ済み',
              dark: 'ダーク',
              light: 'ライト',
              sort: {
                label: '並べ替え:',
                stars: 'スター',
                newest: '最新',
                oldest: '最古',
                lastUpdated: '最終更新',
                mostStale: '最も古い',
                aToZ: 'A-Z',
                zToA: 'Z-A',
              },
            },
            readmePage: {
              title: '$t(grid.spicetifyMarketplace) - README',
              loading: '読み込み中...',
              errorLoading: 'READMEの読み込み中にエラーが発生しました',
            },
            github: 'GitHub',
            install: 'インストール',
            remove: '削除',
            save: '保存',
            colour_one: '色',
            colour_other: '色',
            favourite: 'お気に入り',
            notifications: {
              wrongLocalTheme:
                "config-xpui.iniのcurrent_themeを 'marketplace' に設定して、マーケットプレイスを使用してテーマをインストールしてください",
              tooManyRequests: 'リクエストが多すぎます。時間をおいて再試行してください',
              noCdnConnection: 'マーケットプレイスがCDNに接続できません。インターネットの設定を確認してください',
              markdownParsingError: 'Markdownの解析エラー（HTTP {{status}}）',
              noReadmeFile: 'READMEが見つかりませんでした',
              themeInstallationError: 'テーマのインストール中にエラーが発生しました',
              extensionInstallationError: '拡張機能のインストール中にエラーが発生しました',
            },
          },
        },
      }),
    ma = '1.0.2',
    i = 'marketplace',
    w = {
      installedExtensions: i + ':installed-extensions',
      installedSnippets: i + ':installed-snippets',
      installedThemes: i + ':installed-themes',
      activeTab: i + ':active-tab',
      tabs: i + ':tabs',
      sort: i + ':sort',
      themeInstalled: i + ':theme-installed',
      localTheme: i + ':local-theme',
      albumArtBasedColor: i + ':albumArtBasedColors',
      albumArtBasedColorMode: i + ':albumArtBasedColorsMode',
      albumArtBasedColorVibrancy: i + ':albumArtBasedColorsVibrancy',
      colorShift: i + ':colorShift',
    },
    fa = [
      { name: 'Extensions', enabled: !0 },
      { name: 'Themes', enabled: !0 },
      { name: 'Snippets', enabled: !0 },
      { name: 'Apps', enabled: !0 },
      { name: 'Installed', enabled: !0 },
    ],
    E = 100,
    ga = '/marketplace',
    va = 'https://github.com/spicetify/spicetify-marketplace/releases',
    ba = 'https://api.github.com/repos/spicetify/spicetify-marketplace/releases/latest',
    s = t(b()),
    ya = t(a()),
    C =
      (t(Pe()),
      (t, e) => {
        t = localStorage.getItem(t);
        if (!t) return e;
        try {
          return JSON.parse(t);
        } catch (e) {
          return t;
        }
      }),
    Sa = (e) => {
      const a = { section: /^\s*\[\s*([^\]]*)\s*\]\s*$/, param: /^\s*([^=]+?)\s*=\s*(.*?)\s*$/, comment: /^\s*;.*$/ },
        r = {};
      e = e.split(/[\r\n]+/);
      let n = null;
      return (
        e.forEach(function (e) {
          var t;
          a.comment.test(e) ||
            (a.param.test(e)
              ? e.includes('xrdb')
                ? (delete r[n ?? ''], (n = null))
                : ((t = e.match(a.param)), n && t && (r[n][t[1]] = t[2].split(';')[0].trim()))
              : a.section.test(e)
                ? (t = e.match(a.section)) && ((r[t[1]] = {}), (n = t[1]))
                : 0 == e.length && (n = n && null));
        }),
        r
      );
    },
    ka = (e) => {
      var t = document.querySelector('style.marketplaceSnippets'),
        t = (t && t.remove(), document.createElement('style')),
        e = e.reduce(
          (e, t) =>
            (e =
              (e += `/* ${t.title} - ${t.description} */
`) +
              t.code +
              `
`),
          '',
        );
      (t.innerHTML = e), t.classList.add('marketplaceSnippets'), document.body.appendChild(t);
    },
    wa = (e, t) => {
      let a = [];
      return (
        e && 0 < e.length
          ? (a = e.map((e) => ({ name: e.name, url: Pa(e.url) })))
          : a.push({ name: t, url: 'https://github.com/' + t }),
        a
      );
    },
    Ea = (e) => (e ? Object.keys(e).map((e) => ({ key: e, value: e })) : []),
    Ca = (e) => [
      { key: 'stars', value: e('grid.sort.stars') },
      { key: 'newest', value: e('grid.sort.newest') },
      { key: 'oldest', value: e('grid.sort.oldest') },
      { key: 'lastUpdated', value: e('grid.sort.lastUpdated') },
      { key: 'mostStale', value: e('grid.sort.mostStale') },
      { key: 'a-z', value: e('grid.sort.aToZ') },
      { key: 'z-a', value: e('grid.sort.zToA') },
    ],
    Na = (...e) => {
      console.debug('Resetting Marketplace');
      const t = [];
      0 === e.length &&
        Object.keys(localStorage).forEach((e) => {
          e.startsWith('marketplace:') && t.push(e);
        }),
        e.forEach((e) => {
          switch (e) {
            case 'extensions':
              t.push(...C(w.installedExtensions, [])), t.push(w.installedExtensions);
              break;
            case 'snippets':
              t.push(...C(w.installedSnippets, [])), t.push(w.installedSnippets);
              break;
            case 'theme':
              t.push(...C(w.installedThemes, [])), t.push(w.installedThemes), t.push(w.themeInstalled);
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
    },
    xa = (a) => {
      var e = document.querySelector('style.marketplaceCSS.marketplaceScheme');
      if ((e && e.remove(), a)) {
        e = document.createElement('style');
        e.classList.add('marketplaceCSS'), e.classList.add('marketplaceScheme');
        let t = ':root {';
        Object.keys(a).forEach((e) => {
          t =
            (t += `--spice-${e}: #${a[e]};`) +
            `--spice-rgb-${e}: ${((e) => {
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
            })(a[e])};`;
        }),
          (t += '}'),
          (e.innerHTML = t),
          document.body.appendChild(e);
      }
    },
    Ia = (e) => {
      try {
        var t,
          a,
          r = document.querySelector("link[href='user.css']"),
          n = (r && r.remove(), document.querySelector('style.marketplaceCSS.marketplaceUserCSS'));
        n && n.remove(),
          e
            ? ((t = document.createElement('style')).classList.add('marketplaceCSS'),
              t.classList.add('marketplaceUserCSS'),
              (t.innerHTML = e),
              document.body.appendChild(t))
            : ((a = document.createElement('link')).setAttribute('rel', 'stylesheet'),
              a.setAttribute('href', 'user.css'),
              a.classList.add('userCSS'),
              document.body.appendChild(a));
      } catch (e) {
        console.warn(e);
      }
    },
    La = async (e, t) => {
      if (!e.cssURL) throw new Error('No CSS URL provided');
      t ||= await (async function () {
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
      })();
      var t = ((e) => {
          const t = new URL(e);
          return t.host, t.host === 'raw.githubusercontent.com';
        })(e.cssURL)
          ? `https://cdn.jsdelivr.${t}/gh/${e.user}/${e.repo}@${e.branch}/` + e.manifest.usercss
          : e.cssURL,
        a = t.replace('/user.css', '/assets/');
      console.debug('Parsing CSS: ', t);
      let r = await fetch(t + '?time=' + Date.now()).then((e) => e.text());
      for (const i of r.matchAll(/url\(['|"](?<path>.+?)['|"]\)/gm) || []) {
        var n,
          o = i?.groups?.path;
        !o || o.startsWith('http') || o.startsWith('data') || ((n = a + o.replace(/\.\//g, '')), (r = r.replace(o, n)));
      }
      return r;
    };
  function Oa(e, r) {
    e &&
      e.forEach((e) => {
        var t = r || e.user + '-' + e.repo,
          a = window.sessionStorage.getItem(t),
          a = a ? JSON.parse(a) : [];
        a.push(e), window.sessionStorage.setItem(t, JSON.stringify(a));
      });
  }
  async function Ta(e, t, a) {
    try {
      var r = { text: e, context: t + '/' + a, mode: 'gfm' },
        n = await fetch('https://api.github.com/markdown', { method: 'POST', body: JSON.stringify(r) });
      if (n.ok) return await n.text();
      throw Spicetify.showNotification(y('notifications.markdownParsingError', { status: n.status }), !0);
    } catch (e) {
      return null;
    }
  }
  function Aa(e) {
    var t = 'snippet' === e.type ? 'snippet:' : `${e.item.user}/${e.item.repo}/`;
    let a;
    switch (e.type) {
      case 'snippet':
        a = e.item.title.replaceAll(' ', '-');
        break;
      case 'theme':
        a = e.item.manifest?.usercss || '';
        break;
      case 'extension':
        a = e.item.manifest?.main || '';
        break;
      case 'app':
        a = e.item.manifest?.name?.replaceAll(' ', '-') || '';
    }
    return 'marketplace:installed:' + t + a;
  }
  var Pa = (e) => {
      var t = decodeURI(e).trim().toLowerCase();
      return t.startsWith('javascript:') || t.startsWith('data:') || t.startsWith('vbscript:') ? 'about:blank' : e;
    },
    Ma = (e, t) => {
      (e = e.title || e?.manifest?.name || ''), (t = t.title || t?.manifest?.name || '');
      return e.localeCompare(t);
    },
    _a = (e, t) => {
      return void 0 === e.created || void 0 === t.created
        ? 0
        : ((e = new Date(e.created)), new Date(t.created).getTime() - e.getTime());
    },
    Ra = (e, t) => {
      return void 0 === e.lastUpdated || void 0 === t.lastUpdated
        ? 0
        : ((e = new Date(e.lastUpdated)), new Date(t.lastUpdated).getTime() - e.getTime());
    },
    ja = (e, t) => {
      switch (t) {
        case 'a-z':
          e.sort((e, t) => Ma(e, t));
          break;
        case 'z-a':
          e.sort((e, t) => Ma(t, e));
          break;
        case 'newest':
          e.sort((e, t) => _a(e, t));
          break;
        case 'oldest':
          e.sort((e, t) => _a(t, e));
          break;
        case 'lastUpdated':
          e.sort((e, t) => Ra(e, t));
          break;
        case 'mostStale':
          e.sort((e, t) => Ra(t, e));
          break;
        default:
          e.sort((e, t) => t.stars - e.stars);
      }
    };
  var c = t(b()),
    f = t(b()),
    Da = t(Me()),
    $a = t(_e()),
    za =
      ((i = Prism),
      (a = /(?:"(?:\\(?:\r\n|[\s\S])|[^"\\\r\n])*"|'(?:\\(?:\r\n|[\s\S])|[^'\\\r\n])*')/),
      (i.languages.css = {
        comment: /\/\*[\s\S]*?\*\//,
        atrule: {
          pattern: RegExp(
            '@[\\w-](?:' + /[^;{\s"']|\s+(?!\s)/.source + '|' + a.source + ')*?' + /(?:;|(?=\s*\{))/.source,
          ),
          inside: {
            rule: /^@[\w-]+/,
            'selector-function-argument': {
              pattern: /(\bselector\s*\(\s*(?![\s)]))(?:[^()\s]|\s+(?![\s)])|\((?:[^()]|\([^()]*\))*\))+(?=\s*\))/,
              lookbehind: !0,
              alias: 'selector',
            },
            keyword: { pattern: /(^|[^\w-])(?:and|not|only|or)(?![\w-])/, lookbehind: !0 },
          },
        },
        url: {
          pattern: RegExp('\\burl\\((?:' + a.source + '|' + /(?:[^\\\r\n()"']|\\[\s\S])*/.source + ')\\)', 'i'),
          greedy: !0,
          inside: {
            function: /^url/i,
            punctuation: /^\(|\)$/,
            string: { pattern: RegExp('^' + a.source + '$'), alias: 'url' },
          },
        },
        selector: {
          pattern: RegExp(`(^|[{}\\s])[^{}\\s](?:[^{};"'\\s]|\\s+(?![\\s{])|` + a.source + ')*(?=\\s*\\{)'),
          lookbehind: !0,
        },
        string: { pattern: a, greedy: !0 },
        property: {
          pattern: /(^|[^-\w\xA0-\uFFFF])(?!\s)[-_a-z\xA0-\uFFFF](?:(?!\s)[-\w\xA0-\uFFFF])*(?=\s*:)/i,
          lookbehind: !0,
        },
        important: /!important\b/i,
        function: { pattern: /(^|[^-a-z0-9])[-a-z0-9]+(?=\()/i, lookbehind: !0 },
        punctuation: /[(){};:,]/,
      }),
      (i.languages.css.atrule.inside.rest = i.languages.css),
      (a = i.languages.markup) && (a.tag.addInlined('style', 'css'), a.tag.addAttribute('style', 'css')),
      t(b())),
    Ua = 'button-module__button___hf2qg_marketplace',
    Ba = 'button-module__circle___EZ88P_marketplace',
    g = (e) => {
      var t = e.type || 'round',
        a = [Ua];
      return (
        'circle' === t && a.push(Ba),
        e.classes && a.push(...e.classes),
        za.default.createElement(
          'button',
          { className: a.join(' '), onClick: e.onClick, 'aria-label': e.label || '', disabled: e.disabled },
          e.children,
        )
      );
    },
    Fa = (r) => {
      var e = 'marketplace-customCSS-preview';
      const [n, t] = f.default.useState(('ADD_SNIPPET' !== r.type && r.content?.item.code) || ''),
        [a, o] = f.default.useState(('ADD_SNIPPET' !== r.type && r.content?.item.title) || ''),
        [i, s] = f.default.useState(('ADD_SNIPPET' !== r.type && r.content?.item.description) || ''),
        [l, c] = f.default.useState(('ADD_SNIPPET' !== r.type && r.content?.item.imageURL) || ''),
        u = () => a.replace(/\n/g, '').replaceAll(' ', '-');
      const d = 'marketplace:installed:snippet:' + u(),
        [p, h] = f.default.useState(!!C(d));
      let m;
      return f.default.createElement(
        'div',
        { id: 'marketplace-add-snippet-container' },
        f.default.createElement(
          'div',
          { className: 'marketplace-customCSS-input-container' },
          f.default.createElement('label', { htmlFor: 'marketplace-custom-css' }, y('snippets.customCSS')),
          f.default.createElement(
            'div',
            { className: 'marketplace-code-editor-wrapper marketplace-code-editor' },
            f.default.createElement(Da.default, {
              value: n,
              onValueChange: (e) => t(e),
              highlight: (e) => (0, $a.highlight)(e, $a.languages.css),
              textareaId: 'marketplace-custom-css',
              textareaClassName: 'snippet-code-editor',
              readOnly: 'VIEW_SNIPPET' === r.type,
              placeholder: y('snippets.customCSSPlaceholder'),
              style: {},
            }),
          ),
        ),
        f.default.createElement(
          'div',
          { className: 'marketplace-customCSS-input-container' },
          f.default.createElement('label', { htmlFor: 'marketplace-customCSS-name-submit' }, y('snippets.snippetName')),
          f.default.createElement('input', {
            id: 'marketplace-customCSS-name-submit',
            className: 'marketplace-code-editor',
            value: a,
            onChange: (e) => {
              'VIEW_SNIPPET' !== r.type && o(e.target.value);
            },
            placeholder: y('snippets.snippetNamePlaceholder'),
          }),
        ),
        f.default.createElement(
          'div',
          { className: 'marketplace-customCSS-input-container' },
          f.default.createElement(
            'label',
            { htmlFor: 'marketplace-customCSS-description-submit' },
            y('snippets.snippetDesc'),
          ),
          f.default.createElement('input', {
            id: 'marketplace-customCSS-description-submit',
            className: 'marketplace-code-editor',
            value: i,
            onChange: (e) => {
              'VIEW_SNIPPET' !== r.type && s(e.target.value);
            },
            placeholder: y('snippets.snippetDescPlaceholder'),
          }),
        ),
        f.default.createElement(
          'div',
          { className: 'marketplace-customCSS-input-container' },
          f.default.createElement(
            'label',
            { htmlFor: e },
            y('snippets.snippetPreview'),
            ' ',
            'VIEW_SNIPPET' !== r.type && `(${y('snippets.optional')})`,
          ),
          l &&
            f.default.createElement(
              'label',
              { htmlFor: e, style: { textAlign: 'center' } },
              f.default.createElement('img', {
                className: 'marketplace-customCSS-image-preview',
                src: l,
                alt: 'Preview',
              }),
            ),
        ),
        'VIEW_SNIPPET' !== r.type &&
          f.default.createElement(
            f.default.Fragment,
            null,
            f.default.createElement(
              g,
              {
                onClick: () => {
                  m.click();
                },
              },
              l.length ? y('snippets.changeImage') : y('snippets.addImage'),
              f.default.createElement('input', {
                id: e,
                type: 'file',
                style: { display: 'none' },
                ref: (e) => (m = e),
                onChange: async (e) => {
                  if (e.target.files?.[0])
                    try {
                      r = e.target.files?.[0];
                      var t = await new Promise((e, t) => {
                        const a = new FileReader();
                        a.readAsDataURL(r),
                          (a.onload = () => {
                            e(a.result);
                          }),
                          (a.onerror = (e) => {
                            t(e);
                          });
                      });
                      t && c(t);
                    } catch (e) {
                      console.error(e);
                    }
                  var r;
                },
              }),
            ),
            f.default.createElement(
              g,
              {
                onClick: () => {
                  var e,
                    t = u(),
                    a = i.trim();
                  p && 'EDIT_SNIPPET' !== r.type
                    ? Spicetify.showNotification(y('snippets.duplicateName'), !0)
                    : (console.debug('Installing snippet: ' + t),
                      r.content &&
                        r.content.item.title !== t &&
                        (console.debug('Deleting outdated snippet: ' + r.content.item.title),
                        localStorage.removeItem('marketplace:installed:snippet:' + r.content.item.title),
                        (e = C(w.installedSnippets, []).filter(
                          (e) => e !== 'marketplace:installed:snippet:' + r.content?.item.title,
                        )),
                        localStorage.setItem(w.installedSnippets, JSON.stringify(e))),
                      localStorage.setItem(
                        d,
                        JSON.stringify({ title: t, code: n, description: a, imageURL: l, custom: !0 }),
                      ),
                      -1 === (e = C(w.installedSnippets, [])).indexOf(d) &&
                        (e.push(d), localStorage.setItem(w.installedSnippets, JSON.stringify(e))),
                      (t = e.map((e) => C(e))),
                      ka(t),
                      Spicetify.PopupModal.hide(),
                      'EDIT_SNIPPET' === r.type && location.reload());
                },
                disabled: !u() || !n.replace(/\n/g, '\\n'),
              },
              y('snippets.saveCSS'),
            ),
          ),
        'VIEW_SNIPPET' === r.type &&
          f.default.createElement(
            g,
            {
              onClick: () => {
                r.callback && r.callback(), h(!p);
              },
            },
            p ? y('remove') : y('install'),
          ),
      );
    },
    Va = t(b()),
    Ha = () =>
      Va.default.createElement(
        'div',
        { id: 'marketplace-reload-container' },
        Va.default.createElement('p', null, y('reloadModal.description')),
        Va.default.createElement(
          'div',
          { className: 'marketplace-reload-modal__button-container' },
          Va.default.createElement(
            g,
            {
              onClick: () => {
                Spicetify.PopupModal.hide(), location.reload();
              },
            },
            y('reloadModal.reloadNow'),
          ),
          Va.default.createElement(
            g,
            {
              onClick: () => {
                Spicetify.PopupModal.hide();
              },
            },
            y('reloadModal.reloadLater'),
          ),
        ),
      ),
    u = t(b()),
    d = t(b()),
    qa = t(b()),
    Ga = 'toggle-module__toggle-wrapper___ocE5z_marketplace',
    Ka = 'toggle-module__disabled___OYAYf_marketplace',
    Ja = 'toggle-module__toggle-input___ceLM4_marketplace',
    Wa = 'toggle-module__toggle-indicator-wrapper___6Lcp0_marketplace',
    Za = 'toggle-module__toggle-indicator___nCxwE_marketplace',
    Xa = (e) => {
      var t = 'toggle:' + e.storageKey,
        a = [Ga];
      return (
        !1 === e.clickable && a.push(Ka),
        qa.default.createElement(
          'label',
          { className: a.join(' ') },
          qa.default.createElement('input', {
            className: Ja,
            type: 'checkbox',
            checked: e.enabled,
            'data-storage-key': e.storageKey,
            id: t,
            title: 'Toggle for ' + e.storageKey,
            onChange: e.onChange,
          }),
          qa.default.createElement('span', { className: Wa }, qa.default.createElement('span', { className: Za })),
        )
      );
    },
    Ya = t(b()),
    Qa = t(e()),
    er = (t) => {
      var e = t.sortBoxOptions.map((e) => ({ value: e.key, label: e.value })),
        a = t.sortBoxOptions.find(t.sortBySelectedFn);
      return Ya.default.createElement(
        'div',
        { className: 'marketplace-sortBox' },
        Ya.default.createElement(
          'div',
          { className: 'marketplace-sortBox-header' },
          Ya.default.createElement('div', { className: 'marketplace-sortBox-header-title' }),
          Ya.default.createElement(Qa.default, {
            placeholder: 'Select an option',
            options: e,
            value: a?.key,
            onChange: (e) => {
              t.onChange(e.value);
            },
          }),
        ),
      );
    },
    tr = t(b()),
    ar = () =>
      tr.default.createElement(
        'svg',
        {
          role: 'img',
          height: '16',
          width: '16',
          className: 'Svg-sc-ytk21e-0 uPxdw nW1RKQOkzcJcX6aDCZB4',
          viewBox: '0 0 16 16',
        },
        tr.default.createElement('path', {
          d: 'M8 1.5a6.5 6.5 0 100 13 6.5 6.5 0 000-13zM0 8a8 8 0 1116 0A8 8 0 010 8z',
        }),
        tr.default.createElement('path', {
          d: 'M7.25 12.026v-1.5h1.5v1.5h-1.5zm.884-7.096A1.125 1.125 0 007.06 6.39l-1.431.448a2.625 2.625 0 115.13-.784c0 .54-.156 1.015-.503 1.488-.3.408-.7.652-.973.818l-.112.068c-.185.116-.26.203-.302.283-.046.087-.097.245-.097.57h-1.5c0-.47.072-.898.274-1.277.206-.385.507-.645.827-.846l.147-.092c.285-.177.413-.257.526-.41.169-.23.213-.397.213-.602 0-.622-.503-1.125-1.125-1.125z',
        }),
      ),
    rr = window.Spicetify,
    p = (a) => {
      var e = a.type,
        t = 'dropdown' === e ? 'dropdown:' + a.storageKey : 'toggle:' + a.storageKey,
        r = !!a.modalConfig.visual[a.storageKey];
      return (
        (void 0 !== a.description && null !== a.description) || (a.description = ''),
        'dropdown' === e && a.options
          ? d.default.createElement(
              'div',
              { className: 'settings-row' },
              d.default.createElement('label', { htmlFor: t, className: 'col description' }, a.name),
              d.default.createElement(
                'div',
                { className: 'col action' },
                d.default.createElement(er, {
                  sortBoxOptions: a.options.map((e) => ({ key: e, value: e })),
                  onChange: (e) => {
                    return (
                      (e = e),
                      (t = a.storageKey),
                      (a.modalConfig.visual[t] = e),
                      localStorage.setItem('marketplace:' + t, String(e)),
                      void a.updateConfig(a.modalConfig)
                    );
                    var t;
                  },
                  sortBySelectedFn: (e) => e.key == a.modalConfig.visual[a.storageKey],
                }),
                d.default.createElement(
                  rr.ReactComponent.TooltipWrapper,
                  {
                    label: d.default.createElement(
                      d.default.Fragment,
                      null,
                      a.description
                        .split('\n')
                        .map((e) =>
                          d.default.createElement(d.default.Fragment, null, e, d.default.createElement('br', null)),
                        ),
                    ),
                    renderInline: !0,
                    showDelay: 10,
                    placement: 'top',
                    labelClassName: 'marketplace-settings-tooltip',
                    disabled: !1,
                  },
                  d.default.createElement(
                    'div',
                    { className: 'marketplace-tooltip-icon' },
                    d.default.createElement(ar, null),
                  ),
                ),
              ),
            )
          : d.default.createElement(
              'div',
              { className: 'settings-row' },
              d.default.createElement('label', { htmlFor: t, className: 'col description' }, a.name),
              d.default.createElement(
                'div',
                { className: 'col action' },
                d.default.createElement(Xa, {
                  name: a.name,
                  storageKey: a.storageKey,
                  enabled: r,
                  onChange: (e) => {
                    var t = e.target.checked,
                      e = e.target.dataset.storageKey;
                    (a.modalConfig.visual[e] = t),
                      console.debug(`toggling ${e} to ` + t),
                      localStorage.setItem('marketplace:' + e, String(t)),
                      a.updateConfig(a.modalConfig);
                  },
                }),
              ),
            )
      );
    },
    h = t(b()),
    nr = (r) => {
      var e = 'toggle:' + r.name;
      const t = r.modalConfig.tabs.reduce((e, t, a) => (t.name === r.name ? a : e), -1);
      var a = r.modalConfig.tabs[t]['enabled'];
      function n(e, t) {
        var t = e + t,
          a = r.modalConfig.tabs[t];
        (r.modalConfig.tabs[t] = r.modalConfig.tabs[e]),
          (r.modalConfig.tabs[e] = a),
          localStorage.setItem(w.tabs, JSON.stringify(r.modalConfig.tabs)),
          r.updateConfig(r.modalConfig);
      }
      return h.default.createElement(
        'div',
        { className: 'settings-row' },
        h.default.createElement('label', { htmlFor: e, className: 'col description' }, y('tabs.' + r.name)),
        h.default.createElement(
          'div',
          { className: 'col action' },
          h.default.createElement(
            'button',
            { title: 'Move up', className: 'arrow-btn', disabled: 0 === t, onClick: () => n(t, -1) },
            h.default.createElement('svg', {
              height: '16',
              width: '16',
              viewBox: '0 0 16 16',
              fill: 'currentColor',
              dangerouslySetInnerHTML: { __html: String(Spicetify.SVGIcons['chart-up']) },
            }),
          ),
          h.default.createElement(
            'button',
            {
              title: 'Move down',
              className: 'arrow-btn',
              disabled: t === r.modalConfig.tabs.length - 1,
              onClick: () => n(t, 1),
            },
            h.default.createElement('svg', {
              height: '16',
              width: '16',
              viewBox: '0 0 16 16',
              fill: 'currentColor',
              dangerouslySetInnerHTML: { __html: String(Spicetify.SVGIcons['chart-down']) },
            }),
          ),
          h.default.createElement(Xa, {
            name: r.name,
            storageKey: 'tab:' + r.name,
            clickable: 'Extensions' !== r.name,
            enabled: a,
            onChange: (e) => {
              (r.modalConfig.tabs[t].enabled = e.target.checked),
                localStorage.setItem(w.tabs, JSON.stringify(r.modalConfig.tabs)),
                r.updateConfig(r.modalConfig);
            },
          }),
        ),
      );
    },
    or = async () => {
      const e = new MutationObserver(async () => {
        var t;
        document.querySelector(".GenericModal[aria-label='Settings']") ||
          ((t = 100), await new Promise((e) => setTimeout(e, t)), N('BACKUP'), e.disconnect());
      });
      e.observe(document.body, { childList: !0, subtree: !0 }), Spicetify.PopupModal.hide();
    },
    ir = ({ CONFIG: e, updateAppConfig: t }) => {
      const [a, r] = u.default.useState({ ...e }),
        [n, o] = u.default.useState(y('settings.versionBtn')),
        i = (e) => {
          t({ ...e }), r({ ...e });
        };
      e = document.querySelector('body > generic-modal button.main-trackCreditsModal-closeBtn');
      const s = document.querySelector('body > generic-modal > div');
      e &&
        s &&
        ((e.onclick = () => location.reload()),
        e.setAttribute('style', 'cursor: pointer;'),
        (s.onclick = (e) => {
          e.target === s && location.reload();
        }));
      e = C(w.albumArtBasedColor)
        ? u.default.createElement(
            u.default.Fragment,
            null,
            u.default.createElement(p, {
              name: y('settings.albumArtBasedColorsMode'),
              storageKey: 'albumArtBasedColorsMode',
              modalConfig: a,
              updateConfig: i,
              type: 'dropdown',
              options: ['monochromeDark', 'monochromeLight', 'analogicComplement', 'analogic', 'triad', 'quad'],
              description: y('settings.almbumArtColorsModeToolTip'),
            }),
            u.default.createElement(p, {
              name: y('settings.albumArtBasedColorsVibrancy'),
              storageKey: 'albumArtBasedColorsVibrancy',
              modalConfig: a,
              updateConfig: i,
              type: 'dropdown',
              options: ['desaturated', 'lightVibrant', 'prominent', 'vibrant'],
              description: y('settings.albumArtBasedColorsVibrancyToolTip'),
            }),
          )
        : null;
      return u.default.createElement(
        'div',
        { id: 'marketplace-config-container' },
        u.default.createElement('h2', { className: 'settings-heading' }, y('settings.optionsHeading')),
        u.default.createElement(p, {
          name: y('settings.starCountLabel'),
          storageKey: 'stars',
          modalConfig: a,
          updateConfig: i,
        }),
        u.default.createElement(p, {
          name: y('settings.tagsLabel'),
          storageKey: 'tags',
          modalConfig: a,
          updateConfig: i,
        }),
        u.default.createElement(p, {
          name: y('settings.showArchived'),
          storageKey: 'showArchived',
          modalConfig: a,
          updateConfig: i,
        }),
        u.default.createElement(p, {
          name: y('settings.devToolsLabel'),
          storageKey: 'themeDevTools',
          modalConfig: a,
          updateConfig: i,
        }),
        u.default.createElement(p, {
          name: y('settings.hideInstalledLabel'),
          storageKey: 'hideInstalled',
          modalConfig: a,
          updateConfig: i,
        }),
        u.default.createElement(p, {
          name: y('settings.colourShiftLabel'),
          storageKey: 'colorShift',
          modalConfig: a,
          updateConfig: i,
        }),
        u.default.createElement(p, {
          name: y('settings.albumArtBasedColors'),
          storageKey: 'albumArtBasedColors',
          modalConfig: a,
          updateConfig: i,
        }),
        e,
        u.default.createElement('h2', { className: 'settings-heading' }, y('settings.tabsHeading')),
        u.default.createElement(
          'div',
          { className: 'tabs-container' },
          a.tabs.map(({ name: e }, t) =>
            u.default.createElement(nr, { key: t, name: e, modalConfig: a, updateConfig: i }),
          ),
        ),
        u.default.createElement('h2', { className: 'settings-heading' }, y('settings.resetHeading')),
        u.default.createElement(
          'div',
          { className: 'settings-row' },
          u.default.createElement('label', { className: 'col description' }, y('settings.resetDescription')),
          u.default.createElement(
            'div',
            { className: 'col action' },
            u.default.createElement(g, { onClick: () => Na() }, y('settings.resetBtn')),
          ),
        ),
        u.default.createElement('h2', { className: 'settings-heading' }, y('settings.backupHeading')),
        u.default.createElement(
          'div',
          { className: 'settings-row' },
          u.default.createElement('label', { className: 'col description' }, y('settings.backupLabel')),
          u.default.createElement(
            'div',
            { className: 'col action' },
            u.default.createElement(g, { onClick: or }, y('settings.backupBtn')),
          ),
        ),
        u.default.createElement('h2', null, y('settings.versionHeading')),
        u.default.createElement(
          'div',
          { className: 'setting-row' },
          u.default.createElement('label', { className: 'col description' }, y('grid.spicetifyMarketplace'), ' ', ma),
          u.default.createElement(
            'div',
            { className: 'col action' },
            u.default.createElement(
              g,
              {
                onClick: () => {
                  Spicetify.Platform.ClipboardAPI.copy(ma),
                    o(y('settings.versionCopied')),
                    setTimeout(() => o(y('settings.versionBtn')), 3e3);
                },
              },
              n,
            ),
          ),
        ),
      );
    },
    m = t(b()),
    sr = t(Me()),
    lr = t(_e()),
    cr =
      ((Prism.languages.ini = {
        comment: { pattern: /(^[ \f\t\v]*)[#;][^\n\r]*/m, lookbehind: !0 },
        section: {
          pattern: /(^[ \f\t\v]*)\[[^\n\r\]]*\]?/m,
          lookbehind: !0,
          inside: {
            'section-name': {
              pattern: /(^\[[ \f\t\v]*)[^ \f\t\v\]]+(?:[ \f\t\v]+[^ \f\t\v\]]+)*/,
              lookbehind: !0,
              alias: 'selector',
            },
            punctuation: /\[|\]/,
          },
        },
        key: {
          pattern: /(^[ \f\t\v]*)[^ \f\n\r\t\v=]+(?:[ \f\t\v]+[^ \f\n\r\t\v=]+)*(?=[ \f\t\v]*=)/m,
          lookbehind: !0,
          alias: 'attr-name',
        },
        value: {
          pattern: /(=[ \f\t\v]*)[^ \f\n\r\t\v]+(?:[ \f\t\v]+[^ \f\n\r\t\v]+)*/,
          lookbehind: !0,
          alias: 'attr-value',
          inside: { 'inner-value': { pattern: /^("|').+(?=\1$)/, lookbehind: !0 } },
        },
        punctuation: /=/,
      }),
      localStorage.getItem(w.themeInstalled)),
    ur = cr ? C(cr) : null,
    dr = () => {
      const [a, t] = m.default.useState(
        ur
          ? ((e) => {
              let t = '';
              for (const a in e)
                if (Object.prototype.hasOwnProperty.call(e, a))
                  if ('object' == typeof e[a]) {
                    t += `[${a}]
`;
                    for (const r in e[a])
                      Object.prototype.hasOwnProperty.call(e[a], r) &&
                        (t += `${r}=${e[a][r]}
`);
                  } else
                    t += `${a}=${e[a]}
`;
              return t;
            })(ur.schemes)
          : y('devTools.noThemeInstalled'),
      );
      return m.default.createElement(
        'div',
        { id: 'marketplace-theme-dev-tools-container', className: 'marketplace-theme-dev-tools-container' },
        m.default.createElement(
          'div',
          { className: 'devtools-column' },
          m.default.createElement(
            'label',
            { htmlFor: 'color-ini-editor' },
            m.default.createElement('h2', { className: 'devtools-heading' }, y('devTools.colorIniEditor')),
          ),
          m.default.createElement(
            'div',
            { className: 'marketplace-code-editor-wrapper marketplace-code-editor' },
            m.default.createElement(sr.default, {
              value: a,
              onValueChange: (e) => t(e),
              highlight: (e) => (0, lr.highlight)(e, lr.languages.ini),
              textareaId: 'color-ini-editor',
              textareaClassName: 'color-ini-editor',
              readOnly: !ur,
              placeholder: y('devTools.colorIniEditorPlaceholder'),
              style: { fontFamily: 'monospace', resize: 'none' },
            }),
          ),
          m.default.createElement(
            g,
            {
              onClick: () => {
                var e = a;
                {
                  var t;
                  cr
                    ? ((t = Sa(e)), (ur.schemes = t), localStorage.setItem(cr, JSON.stringify(ur)))
                    : Spicetify.showNotification(y('devTools.noThemeManifest'), !0);
                }
              },
            },
            y('save'),
          ),
        ),
        m.default.createElement(
          'div',
          { className: 'devtools-column' },
          m.default.createElement('h2', { className: 'devtools-heading' }, y('devTools.invalidCSS')),
          m.default.createElement(
            'div',
            { className: 'marketplace-code-editor-wrapper marketplace-code-editor' },
            (function () {
              var e = document.querySelector('body > style.marketplaceCSS.marketplaceUserCSS')?.innerHTML,
                t = new RegExp('.-?[_a-zA-Z]+[_a-zA-Z0-9-]*\\s*{', 'g');
              if (!e) return ['Error: Class name list not found; please create an issue'];
              var a = [];
              for (const o of e.matchAll(t)) {
                var r = o[0].replace(/{/g, '').trim(),
                  n = r.split(' ');
                let t;
                for (let e = 0; e < n.length; e++) {
                  try {
                    t = document.querySelector('' + n[e]);
                  } catch (e) {
                    t = document.getElementsByClassName('' + r);
                  }
                  t || a.push(r);
                }
              }
              return a;
            })().map((e, t) => m.default.createElement('div', { key: t, className: 'invalid-css-text' }, e)),
          ),
        ),
      );
    },
    v = t(b()),
    pr = t(Me()),
    hr = t(_e()),
    mr =
      ((Prism.languages.json = {
        property: { pattern: /(^|[^\\])"(?:\\.|[^\\"\r\n])*"(?=\s*:)/, lookbehind: !0, greedy: !0 },
        string: { pattern: /(^|[^\\])"(?:\\.|[^\\"\r\n])*"(?!\s*:)/, lookbehind: !0, greedy: !0 },
        comment: { pattern: /\/\/.*|\/\*[\s\S]*?(?:\*\/|$)/, greedy: !0 },
        number: /-?\b\d+(?:\.\d+)?(?:e[+-]?\d+)?\b/i,
        punctuation: /[{}[\],]/,
        operator: /:/,
        boolean: /\b(?:false|true)\b/,
        null: { pattern: /\bnull\b/, alias: 'keyword' },
      }),
      (Prism.languages.webmanifest = Prism.languages.json),
      () => {
        const [e, t] = v.default.useState('');
        const a = (t) => {
          if (t) {
            let e;
            try {
              e = JSON.parse(t);
            } catch (e) {
              return void Spicetify.showNotification(y('backupModal.invalidJSON'));
            }
            var a;
            (a = e),
              console.debug('Importing Marketplace'),
              Na(),
              Object.keys(a).forEach((e) => {
                localStorage.setItem(e, a[e]), console.debug('Imported ' + e);
              }),
              location.reload();
          } else Spicetify.showNotification(y('backupModal.noDataPasted'));
        };
        return v.default.createElement(
          'div',
          { id: 'marketplace-backup-container' },
          v.default.createElement(
            'div',
            { className: 'marketplace-backup-input-container' },
            v.default.createElement('label', { htmlFor: 'marketplace-backup' }, y('backupModal.inputLabel')),
            v.default.createElement(
              'div',
              { className: 'marketplace-code-editor-wrapper marketplace-code-editor' },
              v.default.createElement(pr.default, {
                value: e,
                onValueChange: (e) => t(e),
                highlight: (e) => (0, hr.highlight)(e, hr.languages.css),
                textareaId: 'marketplace-import-text',
                textareaClassName: 'import-textarea',
                readOnly: !1,
                className: 'marketplace-code-editor-textarea',
                placeholder: y('backupModal.inputPlaceholder'),
                style: {},
              }),
            ),
          ),
          v.default.createElement(
            v.default.Fragment,
            null,
            v.default.createElement(
              g,
              {
                classes: ['marketplace-backup-button'],
                onClick: () => {
                  var e = (() => {
                    const t = {};
                    return (
                      Object.keys(localStorage).forEach((e) => {
                        e.startsWith('marketplace:') && (t[e] = localStorage.getItem(e));
                      }),
                      t
                    );
                  })();
                  Spicetify.Platform.ClipboardAPI.copy(JSON.stringify(e)),
                    Spicetify.showNotification(y('backupModal.settingsCopied')),
                    Spicetify.PopupModal.hide();
                },
              },
              y('backupModal.exportBtn'),
            ),
            v.default.createElement(
              g,
              {
                classes: ['marketplace-backup-button'],
                onClick: () => {
                  a(e);
                },
              },
              y('backupModal.importBtn'),
            ),
            v.default.createElement(
              g,
              {
                classes: ['marketplace-backup-button'],
                onClick: async () => {
                  var e = await (await (await window.showOpenFilePicker())[0].getFile()).text();
                  a(e);
                },
              },
              y('backupModal.fileImportBtn'),
            ),
          ),
        );
      }),
    S = t(b());
  var fr = function () {
      const [e, t] = S.default.useState(null);
      return (
        S.default.useEffect(() => {
          !(async function () {
            try {
              var { body: e, tag_name: t, message: a } = await (await fetch(ba)).json();
              return e && t && !a
                ? {
                    version: t.replace('v', ''),
                    changelog: await Ta(
                      e.match(/## What's Changed([\s\S]*?)(\r\n\r|\n\n##)/)[1],
                      'spicetify',
                      'spicetify-marketplace',
                    ),
                  }
                : null;
            } catch (e) {
              return console.error(e), null;
            }
          })().then((e) => t(e));
        }, []),
        S.default.createElement(
          'div',
          { id: 'marketplace-update-container' },
          S.default.createElement(
            'div',
            { id: 'marketplace-update-description' },
            S.default.createElement('h4', null, y('updateModal.description')),
            S.default.createElement(
              'a',
              { href: va + '/tag/v1.0.2' },
              y('updateModal.currentVersion', { version: ma }),
            ),
            S.default.createElement(
              'a',
              { href: va + '/tag/v' + e?.version },
              y('updateModal.latestVersion', { version: e?.version }),
            ),
          ),
          S.default.createElement('hr', null),
          S.default.createElement(
            'div',
            { id: 'marketplace-update-whats-changed' },
            S.default.createElement('h3', { className: 'marketplace-update-header' }, y('updateModal.whatsChanged')),
            S.default.createElement(
              'details',
              null,
              S.default.createElement('summary', null, y('updateModal.seeChangelog')),
              S.default.createElement('ul', { dangerouslySetInnerHTML: { __html: e?.changelog ?? '' } }),
            ),
          ),
          S.default.createElement('hr', null),
          S.default.createElement(
            'div',
            { id: 'marketplace-update-guide' },
            S.default.createElement('h3', { className: 'marketplace-update-header' }, y('updateModal.howToUpgrade')),
            S.default.createElement(
              'a',
              { href: 'https://github.com/spicetify/spicetify-marketplace/wiki/Installation' },
              y('updateModal.viewGuide'),
            ),
          ),
        )
      );
    },
    N = (e, t, a, r, n) => {
      (e = ((e, t, a, r, n) => {
        switch (e) {
          case 'ADD_SNIPPET':
            return { title: y('snippets.addTitle'), content: c.default.createElement(Fa, { type: e }), isLarge: !0 };
          case 'EDIT_SNIPPET':
            return {
              title: y('snippets.editTitle'),
              content: c.default.createElement(Fa, { type: e, content: r }),
              isLarge: !0,
            };
          case 'VIEW_SNIPPET':
            return {
              title: y('snippets.viewTitle'),
              content: c.default.createElement(Fa, { type: e, content: r, callback: n }),
              isLarge: !0,
            };
          case 'RELOAD':
            return { title: y('reloadModal.title'), content: c.default.createElement(Ha, null), isLarge: !1 };
          case 'SETTINGS':
            return {
              title: y('settings.title'),
              content: c.default.createElement(ir, { CONFIG: t, updateAppConfig: a }),
              isLarge: !0,
            };
          case 'THEME_DEV_TOOLS':
            return { title: y('devTools.title'), content: c.default.createElement(dr, null), isLarge: !0 };
          case 'BACKUP':
            return { title: y('backupModal.title'), content: c.default.createElement(mr, null), isLarge: !0 };
          case 'UPDATE':
            return { title: y('updateModal.title'), content: c.default.createElement(fr, null), isLarge: !0 };
          default:
            return { title: '', content: c.default.createElement('div', null), isLarge: !1 };
        }
      })(e, t, a, r, n)),
        Spicetify.PopupModal.display(e);
    };
  async function gr(e, t = 1, a = [], r = !1) {
    let n = `https://api.github.com/search/repositories?q=${encodeURIComponent('topic:' + e)}&per_page=100`;
    t && (n += '&page=' + t);
    var o =
      JSON.parse(window.sessionStorage.getItem(e + '-page-' + t) || 'null') ||
      (await fetch(n)
        .then((e) => e.json())
        .catch(() => null));
    return o?.items
      ? (window.sessionStorage.setItem(e + '-page-' + t, JSON.stringify(o)),
        {
          ...o,
          page_count: o.items.length,
          items: o.items.filter((e) => !a.includes(e.html_url) && (r || !e.archived)),
        })
      : (Spicetify.showNotification(y('notifications.tooManyRequests'), !0, 5e3), { items: [] });
  }
  var Pe = new Blob(
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
    ),
    vr = URL.createObjectURL(Pe);
  async function br(e, t, a) {
    var r = e + '-' + t,
      n = window.sessionStorage.getItem(r),
      o = JSON.parse(window.sessionStorage.getItem('noManifests') || '[]');
    if (n) return JSON.parse(n);
    n = `https://raw.githubusercontent.com/${e}/${t}/${a}/manifest.json`;
    if (o.includes(n)) return null;
    let i = await (async function (e) {
      const r = new Worker(vr);
      return new Promise((t) => {
        const a = (e) => {
          r.terminate(), t(e);
        };
        r.postMessage(e),
          r.addEventListener('message', (e) => a(e.data), { once: !0 }),
          r.addEventListener('error', () => a(null), { once: !0 });
      });
    })(n);
    return i ? (Oa((i = Array.isArray(i) ? i : [i]), r), i) : Oa([n], 'noManifests');
  }
  async function yr(e, r, n, o = !1) {
    try {
      var t = e.match(/https:\/\/api\.github\.com\/repos\/(?<user>.+)\/(?<repo>.+)\/contents/);
      if (!t || !t.groups) return null;
      const { user: i, repo: s } = t.groups;
      return (await br(i, s, r)).reduce((e, t) => {
        var a = t.branch || r,
          a = {
            manifest: t,
            title: t.name,
            subtitle: t.description,
            authors: wa(t.authors, i),
            user: i,
            repo: s,
            branch: a,
            imageURL:
              t.preview && t.preview.startsWith('http')
                ? t.preview
                : `https://raw.githubusercontent.com/${i}/${s}/${a}/` + t.preview,
            extensionURL: t.main.startsWith('http')
              ? t.main
              : `https://raw.githubusercontent.com/${i}/${s}/${a}/` + t.main,
            readmeURL:
              t.readme && t.readme.startsWith('http')
                ? t.readme
                : `https://raw.githubusercontent.com/${i}/${s}/${a}/` + t.readme,
            stars: n,
            tags: t.tags,
          };
        return (
          t &&
            t.name &&
            t.description &&
            t.main &&
            ((o && localStorage.getItem(`marketplace:installed:${i}/${s}/` + t.main)) || e.push(a)),
          e
        );
      }, []);
    } catch {
      return null;
    }
  }
  async function Sr(e, r, n) {
    try {
      var t = e.match(/https:\/\/api\.github\.com\/repos\/(?<user>.+)\/(?<repo>.+)\/contents/);
      if (!t || !t.groups) return null;
      const { user: o, repo: i } = t.groups;
      return (await br(o, i, r)).reduce((e, t) => {
        var a = t.branch || r,
          a = {
            manifest: t,
            title: t.name,
            subtitle: t.description,
            authors: wa(t.authors, o),
            user: o,
            repo: i,
            branch: a,
            imageURL:
              t.preview && t.preview.startsWith('http')
                ? t.preview
                : `https://raw.githubusercontent.com/${o}/${i}/${a}/` + t.preview,
            readmeURL:
              t.readme && t.readme.startsWith('http')
                ? t.readme
                : `https://raw.githubusercontent.com/${o}/${i}/${a}/` + t.readme,
            stars: n,
            tags: t.tags,
            cssURL: t.usercss.startsWith('http')
              ? t.usercss
              : `https://raw.githubusercontent.com/${o}/${i}/${a}/` + t.usercss,
            schemesURL: t.schemes
              ? t.schemes.startsWith('http')
                ? t.schemes
                : `https://raw.githubusercontent.com/${o}/${i}/${a}/` + t.schemes
              : null,
            include: t.include,
          };
        return t?.name && t?.usercss && t?.description && e.push(a), e;
      }, []);
    } catch {
      return null;
    }
  }
  async function kr(e, r, n) {
    try {
      var t = e.match(/https:\/\/api\.github\.com\/repos\/(?<user>.+)\/(?<repo>.+)\/contents/);
      if (!t || !t.groups) return null;
      const { user: o, repo: i } = t.groups;
      return (await br(o, i, r)).reduce((e, t) => {
        var a = t.branch || r,
          a = {
            manifest: t,
            title: t.name,
            subtitle: t.description,
            authors: wa(t.authors, o),
            user: o,
            repo: i,
            branch: a,
            imageURL:
              t.preview && t.preview.startsWith('http')
                ? t.preview
                : `https://raw.githubusercontent.com/${o}/${i}/${a}/` + t.preview,
            readmeURL:
              t.readme && t.readme.startsWith('http')
                ? t.readme
                : `https://raw.githubusercontent.com/${o}/${i}/${a}/` + t.readme,
            stars: n,
            tags: t.tags,
          };
        return t && t.name && t.description && e.push(a), e;
      }, []);
    } catch {
      return null;
    }
  }
  var wr = async () => {
      return (
        await fetch('https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/blacklist.json')
          .then((e) => e.json())
          .catch(() => ({}))
      ).repos;
    },
    Er = async () => {
      var e = await fetch(
        'https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/snippets.json',
      )
        .then((e) => e.json())
        .catch(() => []);
      return e.length
        ? e.reduce((e, t) => {
            t = { ...t };
            return (
              t.preview &&
                ((t.imageURL = t.preview.startsWith('http')
                  ? t.preview
                  : 'https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/' + t.preview),
                delete t.preview),
              e.push(t),
              e
            );
          }, [])
        : [];
    },
    Cr = t(b()),
    Nr = class extends Cr.default.Component {
      render() {
        return Cr.default.createElement(
          'div',
          { onClick: this.props.onClick },
          Cr.default.createElement('p', { style: { fontSize: 100, lineHeight: '65px' } }, '»'),
          Cr.default.createElement('span', { style: { fontSize: 20 } }, 'Load more'),
        );
      }
    },
    x = t(b()),
    xr = () =>
      x.default.createElement(
        'svg',
        { width: '100px', height: '100px', viewBox: '0 0 100 100', preserveAspectRatio: 'xMidYMid' },
        x.default.createElement(
          'circle',
          { cx: '50', cy: '50', r: '0', fill: 'none', stroke: 'currentColor', strokeWidth: '2' },
          x.default.createElement('animate', {
            attributeName: 'r',
            repeatCount: 'indefinite',
            dur: '1s',
            values: '0;40',
            keyTimes: '0;1',
            keySplines: '0 0.2 0.8 1',
            calcMode: 'spline',
            begin: '0s',
          }),
          x.default.createElement('animate', {
            attributeName: 'opacity',
            repeatCount: 'indefinite',
            dur: '1s',
            values: '1;0',
            keyTimes: '0;1',
            keySplines: '0.2 0 0.8 1',
            calcMode: 'spline',
            begin: '0s',
          }),
        ),
        x.default.createElement(
          'circle',
          { cx: '50', cy: '50', r: '0', fill: 'none', stroke: 'currentColor', strokeWidth: '2' },
          x.default.createElement('animate', {
            attributeName: 'r',
            repeatCount: 'indefinite',
            dur: '1s',
            values: '0;40',
            keyTimes: '0;1',
            keySplines: '0 0.2 0.8 1',
            calcMode: 'spline',
            begin: '-0.5s',
          }),
          x.default.createElement('animate', {
            attributeName: 'opacity',
            repeatCount: 'indefinite',
            dur: '1s',
            values: '1;0',
            keyTimes: '0;1',
            keySplines: '0.2 0 0.8 1',
            calcMode: 'spline',
            begin: '-0.5s',
          }),
        ),
      ),
    Ir = t(b()),
    Lr = () =>
      Ir.default.createElement(
        'svg',
        {
          role: 'img',
          width: '16',
          height: '16',
          viewBox: '0 0 24 24',
          'aria-hidden': 'true',
          xmlns: 'http://www.w3.org/2000/svg',
        },
        Ir.default.createElement('path', {
          d: 'M24 13.616v-3.232c-1.651-.587-2.694-.752-3.219-2.019v-.001c-.527-1.271.1-2.134.847-3.707l-2.285-2.285c-1.561.742-2.433 1.375-3.707.847h-.001c-1.269-.526-1.435-1.576-2.019-3.219h-3.232c-.582 1.635-.749 2.692-2.019 3.219h-.001c-1.271.528-2.132-.098-3.707-.847l-2.285 2.285c.745 1.568 1.375 2.434.847 3.707-.527 1.271-1.584 1.438-3.219 2.02v3.232c1.632.58 2.692.749 3.219 2.019.53 1.282-.114 2.166-.847 3.707l2.285 2.286c1.562-.743 2.434-1.375 3.707-.847h.001c1.27.526 1.436 1.579 2.019 3.219h3.232c.582-1.636.75-2.69 2.027-3.222h.001c1.262-.524 2.12.101 3.698.851l2.285-2.286c-.744-1.563-1.375-2.433-.848-3.706.527-1.271 1.588-1.44 3.221-2.021zm-12 2.384c-2.209 0-4-1.791-4-4s1.791-4 4-4 4 1.791 4 4-1.791 4-4 4z',
          fill: 'currentColor',
        }),
      ),
    Or = t(b()),
    Tr = () =>
      Or.default.createElement(
        'svg',
        {
          className: 'devtools-icon',
          version: '1.1',
          viewBox: '1 1 22 22',
          xmlSpace: 'preserve',
          xmlns: 'http://www.w3.org/2000/svg',
        },
        Or.default.createElement('g', { className: 'devtools-icon-internal', id: 'grid_system' }),
        Or.default.createElement(
          'g',
          { id: '_icons' },
          Or.default.createElement('path', {
            d: 'M18,12v-0.9l0.7-5.7C18.8,4.5,18.6,3.7,18,3c-0.6-0.6-1.4-1-2.2-1H8.3C7.4,2,6.6,2.4,6,3C5.4,3.7,5.2,4.5,5.3,5.4L6,11.1   V12c0,1.6,1.3,2.9,2.8,3l-0.4,2.9c-0.1,1,0.2,2.1,0.8,2.9S11,22,12,22s2-0.5,2.7-1.2s1-1.8,0.8-2.9L15.2,15   C16.7,14.9,18,13.6,18,12z M7.5,4.3C7.7,4.1,8,4,8.3,4H13v2c0,0.6,0.4,1,1,1s1-0.4,1-1V4h0.7c0.3,0,0.6,0.1,0.8,0.3   c0.2,0.2,0.3,0.5,0.2,0.8L16.1,10H7.9L7.3,5.1C7.2,4.8,7.3,4.6,7.5,4.3z M13.2,19.4c-0.6,0.7-1.8,0.7-2.4,0   c-0.3-0.4-0.4-0.8-0.4-1.3l0.5-3.2h2.3l0.5,3.2C13.7,18.6,13.5,19.1,13.2,19.4z M15,13h-1h-4H9c-0.6,0-1-0.4-1-1h8   C16,12.6,15.6,13,15,13z',
          }),
        ),
      ),
    I = t(b()),
    Ar = t(e()),
    i = class extends I.default.Component {
      constructor(e) {
        super(e);
      }
      render() {
        var e = this.props['t'];
        return this.props.item.enabled
          ? I.default.createElement(
              'li',
              {
                className: 'marketplace-tabBar-headerItem',
                'data-tab': this.props.item.value,
                onClick: (e) => {
                  e.preventDefault(), this.props.switchTo(this.props.item);
                },
              },
              I.default.createElement(
                'a',
                {
                  'aria-current': 'page',
                  className:
                    'marketplace-tabBar-headerItemLink ' + (this.props.item.active ? 'marketplace-tabBar-active' : ''),
                  draggable: 'false',
                  href: '',
                },
                I.default.createElement(
                  'span',
                  { className: 'main-type-mestoBold' },
                  e('tabs.' + this.props.item.value),
                ),
              ),
            )
          : null;
      }
    },
    Pr = qt()(i),
    Mr = I.default.memo(function ({ items: e, switchTo: t }) {
      return I.default.createElement(
        'li',
        { className: 'marketplace-tabBar-headerItem' },
        I.default.createElement(Ar.default, {
          className: 'main-type-mestoBold',
          options: e,
          value: 'More',
          placeholder: 'More',
          onChange: t,
        }),
      );
    }),
    _r = (e) => {
      const t =
        document.querySelector('.Root__main-view .os-resize-observer-host') ??
        document.querySelector('.Root__main-view .os-size-observer');
      if (!t) return null;
      const [a, r] = (0, I.useState)(t.clientWidth),
        n = () => r(t.clientWidth),
        o = () => {
          var e = document.querySelector('.marketplace-tabBar'),
            t = document.querySelector('.main-topBar-topbarContentWrapper');
          e && t
            ? (e &&
                t &&
                '/marketplace' === Spicetify.Platform.History.location.pathname &&
                (t.appendChild(e),
                document.querySelector('.main-topBar-container')?.setAttribute('style', 'contain: unset;')),
              Spicetify.Platform.History.listen(({ pathname: e }) => {
                '/marketplace' != e &&
                  (document.querySelector('.marketplace-tabBar')?.remove(),
                  document.querySelector('.main-topBar-container')?.removeAttribute('style'));
              }))
            : setTimeout(o, 100);
        };
      return (
        (0, I.useEffect)(() => {
          const e = new ResizeObserver(n);
          return (
            e.observe(t),
            () => {
              e.disconnect();
            }
          );
        }),
        (0, I.useEffect)(() => {
          o();
        }),
        I.default.createElement(Rr, {
          windowSize: a,
          links: e.links,
          activeLink: e.activeLink,
          switchCallback: e.switchCallback,
        })
      );
    },
    Rr = I.default.memo(function ({ links: e, activeLink: a, switchCallback: t, windowSize: r = 1 / 0 }) {
      const n = I.default.useRef(null),
        [o, i] = (0, I.useState)([]),
        [s, l] = (0, I.useState)(0),
        [c, u] = (0, I.useState)([]),
        d = e.map(({ name: e, enabled: t }) => {
          return { label: e, value: e, active: e === a, enabled: t };
        });
      return (
        (0, I.useEffect)(() => {
          n.current && l(n.current.clientWidth);
        }, [r, n.current?.clientWidth]),
        (0, I.useEffect)(() => {
          var e;
          n.current && ((e = Array.from(n.current.children).map((e) => e.clientWidth)), i(e));
        }, [e]),
        (0, I.useEffect)(() => {
          if (n.current)
            if (o.reduce((e, t) => e + t, 0) <= s) u([]);
            else {
              var e = Math.max(...o);
              const r = [];
              let a = e;
              o.forEach((e, t) => {
                s >= a + e ? (a += e) : r.push(t);
              }),
                u(r);
            }
        }, [s, o]),
        I.default.createElement(
          'nav',
          { className: 'marketplace-tabBar marketplace-tabBar-nav' },
          I.default.createElement(
            'ul',
            { className: 'marketplace-tabBar-header', ref: n },
            d
              .filter((e, t) => !c.includes(t))
              .map((e) => I.default.createElement(Pr, { key: e.value, item: e, switchTo: t })),
            c.length || 0 === o.length
              ? I.default.createElement(Mr, { items: c.map((e) => d[e]).filter((e) => e), switchTo: t })
              : null,
          ),
        )
      );
    }),
    L = t(b()),
    jr = t(b()),
    Dr = () =>
      jr.default.createElement(
        'svg',
        {
          role: 'img',
          width: '16',
          height: '16',
          viewBox: '0 0 448 512',
          'aria-hidden': 'true',
          xmlns: 'http://www.w3.org/2000/svg',
        },
        jr.default.createElement('path', {
          d: 'M53.21 467c1.562 24.84 23.02 45 47.9 45h245.8c24.88 0 46.33-20.16 47.9-45L416 128H32L53.21 467zM432 32H320l-11.58-23.16c-2.709-5.42-8.25-8.844-14.31-8.844H153.9c-6.061 0-11.6 3.424-14.31 8.844L128 32H16c-8.836 0-16 7.162-16 16V80c0 8.836 7.164 16 16 16h416c8.838 0 16-7.164 16-16V48C448 39.16 440.8 32 432 32z',
          fill: 'currentColor',
        }),
      ),
    $r = t(b()),
    zr = () =>
      $r.default.createElement(
        'svg',
        {
          role: 'img',
          width: '16',
          height: '16',
          viewBox: '0 0 512 512',
          'aria-hidden': 'true',
          xmlns: 'http://www.w3.org/2000/svg',
        },
        $r.default.createElement('path', {
          d: 'M480 352h-133.5l-45.25 45.25C289.2 409.3 273.1 416 256 416s-33.16-6.656-45.25-18.75L165.5 352H32c-17.67 0-32 14.33-32 32v96c0 17.67 14.33 32 32 32h448c17.67 0 32-14.33 32-32v-96C512 366.3 497.7 352 480 352zM432 456c-13.2 0-24-10.8-24-24c0-13.2 10.8-24 24-24s24 10.8 24 24C456 445.2 445.2 456 432 456zM233.4 374.6C239.6 380.9 247.8 384 256 384s16.38-3.125 22.62-9.375l128-128c12.49-12.5 12.49-32.75 0-45.25c-12.5-12.5-32.76-12.5-45.25 0L288 274.8V32c0-17.67-14.33-32-32-32C238.3 0 224 14.33 224 32v242.8L150.6 201.4c-12.49-12.5-32.75-12.5-45.25 0c-12.49 12.5-12.49 32.75 0 45.25L233.4 374.6z',
          fill: 'currentColor',
        }),
      ),
    Ur = t(b()),
    Br = () =>
      Ur.default.createElement(
        'svg',
        { xmlns: 'http://www.w3.org/2000/svg', width: '16', height: '16', viewBox: '0 0 24 24' },
        Ur.default.createElement('path', {
          d: 'M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z',
          fill: 'currentColor',
        }),
      ),
    Fr = t(b()),
    Vr = (e) => {
      return Fr.default.createElement(
        'div',
        { className: 'marketplace-card__authors' },
        e.authors.map((e, t) =>
          Fr.default.createElement(
            'a',
            {
              title: e.name,
              className: 'marketplace-card__author',
              href: e.url,
              draggable: 'false',
              dir: 'auto',
              target: '_blank',
              rel: 'noopener noreferrer',
              onClick: (e) => e.stopPropagation(),
              key: t,
            },
            e.name,
          ),
        ),
      );
    },
    Hr = t(b()),
    qr = (r) => {
      const [e, t] = Hr.default.useState(!1),
        n = {
          [y('grid.externalJS')]: 'external JS',
          [y('grid.archived')]: 'archived',
          [y('grid.dark')]: 'dark',
          [y('grid.light')]: 'light',
        };
      var a = (e) => {
        return e
          .filter((e, t, a) => a.indexOf(e) === t)
          .reduce((e, t) => {
            var a = n[t] || t;
            return (
              (!r.showTags && t !== y('grid.externalJS') && t !== y('grid.archived')) ||
                e.push(
                  Hr.default.createElement(
                    'li',
                    { className: 'marketplace-card__tag', draggable: !1, 'data-tag': a },
                    t,
                  ),
                ),
              e
            );
          }, []);
      };
      let o = r.tags.sort((e) => (e === y('grid.externalJS') || e === y('grid.archived') ? -1 : 1)),
        i = [];
      return (
        1 < o.length - 4 && ((i = r.tags.slice(4)), (o = o.slice(0, 4))),
        Hr.default.createElement(
          'div',
          { className: 'marketplace-card__tags-container' },
          Hr.default.createElement('ul', { className: 'marketplace-card__tags' }, a(o), i.length && e ? a(i) : null),
          i.length && !e
            ? Hr.default.createElement(
                'button',
                {
                  className: 'marketplace-card__tags-more-btn',
                  onClick: (e) => {
                    e.stopPropagation(), t(!0);
                  },
                },
                '...',
              )
            : null,
        )
      );
    },
    O = window.Spicetify,
    Gr = class extends L.default.Component {
      tags;
      menuType;
      localStorageKey;
      key = null;
      type = Gr;
      constructor(e) {
        super(e),
          (this.menuType = O.ReactComponent.Menu),
          (this.localStorageKey = Aa(e)),
          Object.assign(this, e),
          (this.tags = e.item.tags || []),
          e.item.include && this.tags.push(y('grid.externalJS')),
          e.item.archived && this.tags.push(y('grid.archived')),
          (this.state = {
            installed: null !== localStorage.getItem(this.localStorageKey),
            stars: this.props.item.stars || 0,
            tagsExpanded: !1,
            externalUrl:
              this.props.item.user && this.props.item.repo
                ? `https://github.com/${this.props.item.user}/` + this.props.item.repo
                : '',
            lastUpdated: this.props.item.user && this.props.item.repo ? this.props.item.lastUpdated : void 0,
            created: this.props.item.user && this.props.item.repo ? this.props.item.created : void 0,
          });
      }
      isInstalled() {
        return null !== localStorage.getItem(this.localStorageKey);
      }
      async componentDidMount() {
        if ('Installed' === this.props.CONFIG.activeTab && 'snippet' !== this.props.type) {
          var e = `https://api.github.com/repos/${this.props.item.user}/` + this.props.item.repo,
            { stargazers_count: e, pushed_at: t } = await fetch(e).then((e) => e.json());
          if (
            (this.state.stars !== e && this.props.CONFIG.visual.stars && console.debug('Stars updated to: ' + e),
            this.state.lastUpdated !== t)
          )
            switch ((console.debug('New update pushed at: ' + t), this.props.type)) {
              case 'extension':
                this.installExtension();
                break;
              case 'theme':
                this.installTheme(!0);
            }
        }
      }
      buttonClicked() {
        if ('extension' === this.props.type)
          this.isInstalled()
            ? (console.debug('Extension already installed, removing'), this.removeExtension())
            : this.installExtension(),
            N('RELOAD');
        else if ('theme' === this.props.type) {
          var e = localStorage.getItem(w.themeInstalled),
            e = e ? C(e, {}) : {};
          if (this.isInstalled())
            console.debug('Theme already installed, removing'), this.removeTheme(this.localStorageKey);
          else {
            var t = localStorage.getItem(w.localTheme);
            if (null != t && 'marketplace' !== t.toLowerCase())
              return void O.showNotification(y('notifications.wrongLocalTheme'), !0, 5e3);
            this.removeTheme(), this.installTheme();
          }
          (this.props.item.manifest?.include || e.include) && N('RELOAD');
        } else
          'app' === this.props.type
            ? window.open(this.state.externalUrl, '_blank')
            : 'snippet' === this.props.type
              ? this.isInstalled()
                ? (console.debug('Snippet already installed, removing'), this.removeSnippet())
                : this.installSnippet()
              : console.error('Unknown card type');
      }
      installExtension() {
        var e, t, a, r, n, o, i, s, l, c, u, d;
        console.debug('Installing extension ' + this.localStorageKey),
          this.props.item
            ? (({
                manifest: d,
                title: e,
                subtitle: t,
                authors: a,
                user: r,
                repo: n,
                branch: o,
                imageURL: i,
                extensionURL: s,
                readmeURL: l,
                lastUpdated: c,
                created: u,
              } = this.props.item),
              localStorage.setItem(
                this.localStorageKey,
                JSON.stringify({
                  manifest: d,
                  type: this.props.type,
                  title: e,
                  subtitle: t,
                  authors: a,
                  user: r,
                  repo: n,
                  branch: o,
                  imageURL: i,
                  extensionURL: s,
                  readmeURL: l,
                  stars: this.state.stars,
                  lastUpdated: c,
                  created: u,
                }),
              ),
              -1 === (d = C(w.installedExtensions, [])).indexOf(this.localStorageKey) &&
                (d.push(this.localStorageKey), localStorage.setItem(w.installedExtensions, JSON.stringify(d))),
              console.debug('Installed'),
              this.setState({ installed: !0 }))
            : O.showNotification(y('notifications.extensionInstallationError'), !0);
      }
      removeExtension() {
        var e;
        localStorage.getItem(this.localStorageKey) &&
          (console.debug('Removing extension ' + this.localStorageKey),
          localStorage.removeItem(this.localStorageKey),
          (e = C(w.installedExtensions, []).filter((e) => e !== this.localStorageKey)),
          localStorage.setItem(w.installedExtensions, JSON.stringify(e)),
          console.debug('Removed'),
          this.setState({ installed: !1 }));
      }
      async installTheme(a = !1) {
        var r = this.props['item'];
        if (r) {
          console.debug('Installing theme ' + this.localStorageKey);
          let e = {},
            t = null;
          a
            ? (({ schemes: a, activeScheme: n } = C(this.localStorageKey, {})), (e = a), (t = n))
            : r.schemesURL && ((a = await (await fetch(r.schemesURL)).text()), (e = Sa(a)));
          var n = t || Object.keys(e)[0] || null,
            {
              manifest: a,
              title: o,
              subtitle: i,
              authors: s,
              user: l,
              repo: c,
              branch: u,
              imageURL: d,
              extensionURL: p,
              readmeURL: h,
              cssURL: m,
              schemesURL: f,
              include: g,
              lastUpdated: v,
              created: b,
            } = (console.debug(e, n), r),
            a =
              (localStorage.setItem(
                this.localStorageKey,
                JSON.stringify({
                  manifest: a,
                  type: this.props.type,
                  title: o,
                  subtitle: i,
                  authors: s,
                  user: l,
                  repo: c,
                  branch: u,
                  imageURL: d,
                  extensionURL: p,
                  readmeURL: h,
                  stars: this.state.stars,
                  tags: this.tags,
                  cssURL: m,
                  schemesURL: f,
                  include: g,
                  schemes: e,
                  activeScheme: n,
                  lastUpdated: v,
                  created: b,
                }),
              ),
              C(w.installedThemes, []));
          -1 === a.indexOf(this.localStorageKey) &&
            (a.push(this.localStorageKey),
            localStorage.setItem(w.installedThemes, JSON.stringify(a)),
            localStorage.setItem(w.themeInstalled, this.localStorageKey)),
            console.debug('Installed'),
            r.include ||
              (this.fetchAndInjectUserCSS(this.localStorageKey),
              this.props.updateActiveTheme(this.localStorageKey),
              this.props.updateColourSchemes(e, n),
              (o = this.props.item.manifest?.name) && (O.Config.current_theme = o),
              n && (O.Config.color_scheme = n)),
            this.setState({ installed: !0 });
        } else O.showNotification(y('notifications.themeInstallationError'), !0);
      }
      removeTheme(t) {
        var e = (t = t || localStorage.getItem(w.themeInstalled)) && localStorage.getItem(t);
        t &&
          e &&
          (console.debug('Removing theme ' + t),
          localStorage.removeItem(t),
          localStorage.removeItem(w.themeInstalled),
          (e = C(w.installedThemes, []).filter((e) => e !== t)),
          localStorage.setItem(w.installedThemes, JSON.stringify(e)),
          console.debug('Removed'),
          this.fetchAndInjectUserCSS(null),
          this.props.updateActiveTheme(null),
          this.props.updateColourSchemes(null, null),
          (O.Config.current_theme = 'marketplace'),
          (O.Config.color_scheme = 'marketplace'),
          this.setState({ installed: !1 }));
      }
      installSnippet() {
        console.debug('Installing snippet ' + this.localStorageKey),
          localStorage.setItem(
            this.localStorageKey,
            JSON.stringify({
              code: this.props.item.code,
              title: this.props.item.title,
              description: this.props.item.description,
              imageURL: this.props.item.imageURL,
            }),
          );
        var e = C(w.installedSnippets, []),
          e =
            (-1 === e.indexOf(this.localStorageKey) &&
              (e.push(this.localStorageKey), localStorage.setItem(w.installedSnippets, JSON.stringify(e))),
            e.map((e) => C(e)));
        ka(e), this.setState({ installed: !0 });
      }
      removeSnippet() {
        localStorage.removeItem(this.localStorageKey);
        var e = C(w.installedSnippets, []).filter((e) => e !== this.localStorageKey),
          e = (localStorage.setItem(w.installedSnippets, JSON.stringify(e)), e.map((e) => C(e)));
        ka(e), this.setState({ installed: !1 });
      }
      async fetchAndInjectUserCSS(e) {
        try {
          var t = window.sessionStorage.getItem('marketplace-request-tld') || void 0,
            a = e ? await La(this.props.item, t) : void 0;
          Ia(a);
        } catch (e) {
          console.warn(e);
        }
      }
      openReadme() {
        this.props.item?.manifest?.readme
          ? O.Platform.History.push({
              pathname: ga + '/readme',
              state: {
                data: {
                  title: this.props.item.title,
                  user: this.props.item.user,
                  repo: this.props.item.repo,
                  branch: this.props.item.branch,
                  readmeURL: this.props.item.readmeURL,
                  type: this.props.type,
                  install: this.buttonClicked.bind(this),
                  isInstalled: this.isInstalled.bind(this),
                },
              },
            })
          : O.showNotification(y('notifications.noReadmeFile'), !0);
      }
      render() {
        var e,
          t,
          a = this.isInstalled();
        return 'Installed' !== this.props.CONFIG.activeTab || a
          ? ((e = ['main-card-card', 'marketplace-card--' + this.props.type]),
            a && e.push('marketplace-card--installed'),
            (t = []),
            'snippet' !== this.props.type && this.props.visual.stars && t.push('★ ' + this.state.stars),
            L.default.createElement(
              'div',
              {
                className: e.join(' '),
                onClick: () => {
                  if ('snippet' === this.props.type) {
                    var e = this.props.item.title.replace(/\n/g, '');
                    if (C('marketplace:installed:snippet:' + e)?.custom)
                      return N('EDIT_SNIPPET', void 0, void 0, this.props);
                    N('VIEW_SNIPPET', void 0, void 0, this.props, this.buttonClicked.bind(this));
                  } else this.openReadme();
                },
              },
              L.default.createElement(
                'div',
                { className: 'main-card-draggable', draggable: 'true' },
                L.default.createElement(
                  'div',
                  { className: 'main-card-imageContainer' },
                  L.default.createElement(
                    'div',
                    { className: 'main-cardImage-imageWrapper' },
                    L.default.createElement(
                      'div',
                      null,
                      L.default.createElement('img', {
                        alt: '',
                        'aria-hidden': 'false',
                        draggable: 'false',
                        loading: 'lazy',
                        src: this.props.item.imageURL,
                        className: 'main-image-image main-cardImage-image',
                        onError: (e) => {
                          e.currentTarget.setAttribute(
                            'src',
                            'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII',
                          ),
                            e.currentTarget
                              .closest('.main-cardImage-imageWrapper')
                              ?.classList.add('main-cardImage-imageWrapper--error');
                        },
                      }),
                    ),
                  ),
                ),
                L.default.createElement(
                  'div',
                  { className: 'main-card-cardMetadata' },
                  L.default.createElement(
                    'a',
                    {
                      draggable: 'false',
                      title: 'snippet' === this.props.type ? this.props.item.title : this.props.item.manifest?.name,
                      className: 'main-cardHeader-link',
                      dir: 'auto',
                      href:
                        'snippet' !== this.props.type
                          ? this.state.externalUrl
                          : 'https://github.com/spicetify/spicetify-marketplace/blob/main/src/resources/snippets.ts',
                      target: '_blank',
                      rel: 'noopener noreferrer',
                      onClick: (e) => e.stopPropagation(),
                    },
                    L.default.createElement(
                      'div',
                      { className: 'main-cardHeader-text main-type-balladBold' },
                      this.props.item.title,
                    ),
                  ),
                  L.default.createElement(
                    'div',
                    { className: 'main-cardSubHeader-root main-type-mestoBold marketplace-cardSubHeader' },
                    this.props.item.authors && L.default.createElement(Vr, { authors: this.props.item.authors }),
                    L.default.createElement('span', null, t.join(' ‒ ')),
                  ),
                  L.default.createElement(
                    'p',
                    { className: 'marketplace-card-desc' },
                    'snippet' === this.props.type ? this.props.item.description : this.props.item.manifest?.description,
                  ),
                  this.props.item.lastUpdated &&
                    L.default.createElement(
                      'p',
                      { className: 'marketplace-card-desc' },
                      y('grid.lastUpdated', {
                        val: new Date(this.props.item.lastUpdated),
                        formatParams: { val: { year: 'numeric', month: 'long', day: 'numeric' } },
                      }),
                    ),
                  this.tags.length
                    ? L.default.createElement(
                        'div',
                        { className: 'marketplace-card__bottom-meta main-type-mestoBold' },
                        L.default.createElement(qr, { tags: this.tags, showTags: this.props.CONFIG.visual.tags }),
                      )
                    : null,
                  a &&
                    L.default.createElement(
                      'div',
                      { className: 'marketplace-card__bottom-meta main-type-mestoBold' },
                      '✓ ',
                      y('grid.installed'),
                    ),
                  L.default.createElement(
                    O.ReactComponent.TooltipWrapper,
                    { label: 'app' === this.props.type ? y('github') : y(a ? 'remove' : 'install'), renderInline: !0 },
                    L.default.createElement(
                      'div',
                      { className: 'main-card-PlayButtonContainer' },
                      L.default.createElement(
                        g,
                        {
                          classes: ['marketplace-installButton'],
                          type: 'circle',
                          label: 'app' === this.props.type ? y('github') : y(a ? 'remove' : 'install'),
                          onClick: (e) => {
                            e.stopPropagation(), this.buttonClicked();
                          },
                        },
                        'app' === this.props.type
                          ? L.default.createElement(Br, null)
                          : a
                            ? L.default.createElement(Dr, null)
                            : L.default.createElement(zr, null),
                      ),
                    ),
                  ),
                ),
              ),
            ))
          : (console.debug('Card item not installed'), null);
      }
    },
    Kr = qt()(Gr),
    Jr = window.Spicetify,
    a = class extends s.default.Component {
      constructor(e) {
        super(e),
          Object.assign(this, e),
          (this.updateAppConfig = e.updateAppConfig.bind(this)),
          (this.sortConfig = { by: C(w.sort, 'top') }),
          (this.state = {
            version: ma,
            newUpdate: !1,
            searchValue: '',
            cards: [],
            tabs: e.CONFIG.tabs,
            rest: !0,
            endOfList: !1,
            schemes: e.CONFIG.theme.schemes,
            activeScheme: e.CONFIG.theme.activeScheme,
            activeThemeKey: e.CONFIG.theme.activeThemeKey,
          });
      }
      searchRequested;
      endOfList = !1;
      lastScroll = 0;
      requestQueue = [];
      requestPage = 0;
      cardList = [];
      sortConfig;
      gridUpdateTabs;
      gridUpdatePostsVisual;
      checkScroll;
      CONFIG;
      updateAppConfig;
      BLACKLIST;
      SNIPPETS;
      getInstalledTheme() {
        var e = localStorage.getItem(w.themeInstalled);
        return (e = e && localStorage.getItem(e)) ? JSON.parse(e) : null;
      }
      newRequest(e) {
        this.cardList = [];
        var t = [];
        this.requestQueue.unshift(t), this.loadAmount(t, e);
      }
      appendCard(e, t, a) {
        a === this.props.CONFIG.activeTab &&
          ((a = s.default.createElement(Kr, {
            item: e,
            key: `${this.props.CONFIG.activeTab}:${e.user}:` + e.title,
            CONFIG: this.CONFIG,
            visual: this.props.CONFIG.visual,
            type: t,
            activeThemeKey: this.state.activeThemeKey,
            updateColourSchemes: this.updateColourSchemes.bind(this),
            updateActiveTheme: this.setActiveTheme.bind(this),
          })),
          this.cardList.push(a));
      }
      updateSort(e) {
        e && ((this.sortConfig.by = e), localStorage.setItem(w.sort, e)),
          (this.requestPage = 0),
          (this.cardList = []),
          this.setState({ cards: [], rest: !1, endOfList: !1 }),
          (this.endOfList = !1),
          this.newRequest(E);
      }
      updateTabs() {
        this.setState({ tabs: [...this.props.CONFIG.tabs] });
      }
      updatePostsVisual() {
        (this.cardList = this.cardList.map((e, t) =>
          s.default.createElement(Kr, { ...e.props, key: t.toString(), CONFIG: this.CONFIG }),
        )),
          this.setState({ cards: [...this.cardList] });
      }
      switchTo(e) {
        (this.CONFIG.activeTab = e.value),
          localStorage.setItem(w.activeTab, e.value),
          (this.cardList = []),
          (this.requestPage = 0),
          this.setState({ cards: [], rest: !1, endOfList: !1 }),
          (this.endOfList = !1),
          this.newRequest(E);
      }
      async loadPage(t) {
        const a = this.CONFIG.activeTab;
        switch (a) {
          case 'Extensions':
            var e = await gr('spicetify-extensions', this.requestPage, this.BLACKLIST, this.CONFIG.visual.showArchived),
              r = [];
            for (const h of e.items) {
              var n = await yr(h.contents_url, h.default_branch, h.stargazers_count, this.CONFIG.visual.hideInstalled);
              if (1 < this.requestQueue.length && t !== this.requestQueue[0]) return -1;
              n &&
                n.length &&
                r.push(
                  ...n.map((e) => ({ ...e, archived: h.archived, lastUpdated: h.pushed_at, created: h.created_at })),
                );
            }
            ja(r, localStorage.getItem('marketplace:sort') || 'stars');
            for (const m of r) this.appendCard(m, 'extension', a);
            this.setState({ cards: this.cardList });
            var o = -1 < this.requestPage && this.requestPage ? this.requestPage : 1,
              i = E * (o - 1) + e.page_count,
              s = e.total_count - i;
            if ((console.debug(`Parsed ${i}/${e.total_count} extensions`), 0 < s)) return o + 1;
            console.debug('No more extension results');
            break;
          case 'Installed':
            var l = {
              theme: C(w.installedThemes, []),
              extension: C(w.installedExtensions, []),
              snippet: C(w.installedSnippets, []),
            };
            for (const f in l)
              if (l[f].length) {
                const g = [];
                l[f].forEach(async (e) => {
                  e = C(e);
                  if (1 < this.requestQueue.length && t !== this.requestQueue[0]) return -1;
                  g.push(e);
                }),
                  ja(g, localStorage.getItem('marketplace:sort') || 'stars');
                for (const v of g) this.appendCard(v, f, a);
              }
            this.setState({ cards: this.cardList });
            break;
          case 'Themes':
            var i = await gr('spicetify-themes', this.requestPage, this.BLACKLIST, this.CONFIG.visual.showArchived),
              c = [];
            for (const b of i.items) {
              var u = await Sr(b.contents_url, b.default_branch, b.stargazers_count);
              if (1 < this.requestQueue.length && t !== this.requestQueue[0]) return -1;
              u &&
                u.length &&
                c.push(
                  ...u.map((e) => ({ ...e, archived: b.archived, lastUpdated: b.pushed_at, created: b.created_at })),
                );
            }
            this.setState({ cards: this.cardList }), ja(c, localStorage.getItem('marketplace:sort') || 'stars');
            for (const y of c) this.appendCard(y, 'theme', a);
            (e = -1 < this.requestPage && this.requestPage ? this.requestPage : 1),
              (s = E * (e - 1) + i.page_count),
              (o = i.total_count - s);
            if ((console.debug(`Parsed ${s}/${i.total_count} themes`), 0 < o)) return e + 1;
            console.debug('No more theme results');
            break;
          case 'Apps':
            var s = await gr('spicetify-apps', this.requestPage, this.BLACKLIST, this.CONFIG.visual.showArchived),
              d = [];
            for (const S of s.items) {
              var p = await kr(S.contents_url, S.default_branch, S.stargazers_count);
              if (1 < this.requestQueue.length && t !== this.requestQueue[0]) return -1;
              p &&
                p.length &&
                d.push(
                  ...p.map((e) => ({ ...e, archived: S.archived, lastUpdated: S.pushed_at, created: S.created_at })),
                );
            }
            this.setState({ cards: this.cardList }), ja(d, localStorage.getItem('marketplace:sort') || 'stars');
            for (const k of d) this.appendCard(k, 'app', a);
            (i = -1 < this.requestPage && this.requestPage ? this.requestPage : 1),
              (o = E * (i - 1) + s.page_count),
              (e = s.total_count - o);
            if ((console.debug(`Parsed ${o}/${s.total_count} apps`), 0 < e)) return i + 1;
            console.debug('No more app results');
            break;
          case 'Snippets':
            o = this.SNIPPETS;
            if (1 < this.requestQueue.length && t !== this.requestQueue[0]) return -1;
            o &&
              o.length &&
              (ja(o, localStorage.getItem('marketplace:sort') || 'stars'),
              o.forEach((e) => this.appendCard(e, 'snippet', a)),
              this.setState({ cards: this.cardList }));
        }
        return this.setState({ rest: !0, endOfList: !0 }), (this.endOfList = !0), 0;
      }
      async loadAmount(t, e = E) {
        for (
          this.setState({ rest: !1 }), e += this.cardList.length, this.requestPage = await this.loadPage(t);
          this.requestPage && -1 !== this.requestPage && this.cardList.length < e && !this.state.endOfList;

        )
          this.requestPage = await this.loadPage(t);
        -1 === this.requestPage
          ? (this.requestQueue = this.requestQueue.filter((e) => e !== t))
          : (this.requestQueue.shift(), this.setState({ rest: !0 }));
      }
      loadMore() {
        this.state.rest && !this.endOfList && this.loadAmount(this.requestQueue[0], E);
      }
      updateColourSchemes(e, t) {
        console.debug('updateColourSchemes', e, t),
          (this.CONFIG.theme.schemes = e),
          (this.CONFIG.theme.activeScheme = t) && (Jr.Config.color_scheme = t),
          e && t && e[t] ? xa(this.CONFIG.theme.schemes[t]) : xa(null);
        var a = C(w.themeInstalled),
          r = C(a);
        r
          ? ((r.activeScheme = t), console.debug(r), localStorage.setItem(a, JSON.stringify(r)))
          : console.debug('No installed theme data'),
          this.setState({ schemes: e, activeScheme: t });
      }
      async componentDidMount() {
        fetch(ba)
          .then((e) => e.json())
          .then(
            (e) => {
              if (e.message) throw e;
              this.setState({ version: e.name });
              try {
                this.setState({ newUpdate: ya.default.gt(e.name, ma) });
              } catch (e) {
                console.error(e);
              }
            },
            (e) => {
              console.error('Failed to check for updates', e);
            },
          ),
          (this.gridUpdateTabs = this.updateTabs.bind(this)),
          (this.gridUpdatePostsVisual = this.updatePostsVisual.bind(this));
        var e =
          document.querySelector('.os-viewport') ?? document.querySelector('#main .main-view-container__scroll-node');
        (this.checkScroll = this.isScrolledBottom.bind(this)),
          e && (e.addEventListener('scroll', this.checkScroll), this.cardList.length)
            ? 0 < this.lastScroll && e.scrollTo(0, this.lastScroll)
            : ((this.BLACKLIST = await wr()), (this.SNIPPETS = await Er()), this.newRequest(E));
      }
      componentWillUnmount() {
        this.gridUpdateTabs = this.gridUpdatePostsVisual = null;
        var e =
          document.querySelector('.os-viewport') ?? document.querySelector('#main .main-view-container__scroll-node');
        e && ((this.lastScroll = e.scrollTop), e.removeEventListener('scroll', this.checkScroll));
      }
      isScrolledBottom(e) {
        e = e.target;
        e.scrollTop + e.clientHeight >= e.scrollHeight && this.loadMore();
      }
      setActiveTheme(e) {
        (this.CONFIG.theme.activeThemeKey = e), this.setState({ activeThemeKey: e });
      }
      getActiveScheme() {
        return this.state.activeScheme;
      }
      render() {
        const a = this.props['t'];
        return s.default.createElement(
          'section',
          { className: 'contentSpacing' },
          s.default.createElement(
            'div',
            { className: 'marketplace-header' },
            s.default.createElement(
              'div',
              { className: 'marketplace-header__left' },
              this.state.newUpdate
                ? s.default.createElement(
                    'button',
                    {
                      type: 'button',
                      title: a('grid.newUpdate'),
                      className: 'marketplace-header-icon-button',
                      id: 'marketplace-update',
                      onClick: () => N('UPDATE'),
                    },
                    s.default.createElement(zr, null),
                    ' ',
                    this.state.version,
                  )
                : null,
              s.default.createElement('h2', { className: 'marketplace-header__label' }, a('grid.sort.label')),
              s.default.createElement(er, {
                onChange: (e) => this.updateSort(e),
                sortBoxOptions: Ca(a),
                sortBySelectedFn: (e) => e.key === this.CONFIG.sort,
              }),
            ),
            s.default.createElement(
              'div',
              { className: 'marketplace-header__right' },
              this.CONFIG.visual.themeDevTools
                ? s.default.createElement(
                    Jr.ReactComponent.TooltipWrapper,
                    { label: a('devTools.title'), renderInline: !0, placement: 'bottom' },
                    s.default.createElement(
                      'button',
                      {
                        type: 'button',
                        'aria-label': a('devTools.title'),
                        className: 'marketplace-header-icon-button',
                        onClick: () => N('THEME_DEV_TOOLS'),
                      },
                      s.default.createElement(Tr, null),
                    ),
                  )
                : null,
              this.state.activeScheme
                ? s.default.createElement(er, {
                    onChange: (e) => this.updateColourSchemes(this.state.schemes, e),
                    sortBoxOptions: Ea(this.state.schemes),
                    sortBySelectedFn: (e) => e.key === this.getActiveScheme(),
                  })
                : null,
              s.default.createElement(
                'div',
                { className: 'searchbar--bar__wrapper' },
                s.default.createElement('input', {
                  className: 'searchbar-bar',
                  type: 'text',
                  placeholder: `${a('grid.search')} ${a('tabs.' + this.CONFIG.activeTab)}...`,
                  value: this.state.searchValue,
                  onChange: (e) => {
                    this.setState({ searchValue: e.target.value });
                  },
                }),
              ),
              s.default.createElement(
                Jr.ReactComponent.TooltipWrapper,
                { label: a('settings.title'), renderInline: !0, placement: 'bottom' },
                s.default.createElement(
                  'button',
                  {
                    type: 'button',
                    'aria-label': a('settings.title'),
                    className: 'marketplace-header-icon-button',
                    id: 'marketplace-settings-button',
                    onClick: () => N('SETTINGS', this.CONFIG, this.updateAppConfig),
                  },
                  s.default.createElement(Lr, null),
                ),
              ),
            ),
          ),
          [
            { handle: 'extension', name: 'Extensions' },
            { handle: 'theme', name: 'Themes' },
            { handle: 'snippet', name: 'Snippets' },
            { handle: 'app', name: 'Apps' },
          ].map((t) => {
            var e = this.cardList
              .filter((e) => e.props.type === t.handle)
              .filter((e) => {
                const t = this.state.searchValue.trim().toLowerCase();
                var { title: e, user: a, authors: r, tags: n } = e.props.item;
                return (
                  !t ||
                  e.toLowerCase().includes(t) ||
                  a?.toLowerCase().includes(t) ||
                  r?.some((e) => e.name.toLowerCase().includes(t)) ||
                  n?.some((e) => e.toLowerCase().includes(t))
                );
              })
              .map((e) => s.default.cloneElement(e, { activeThemeKey: this.state.activeThemeKey, key: e.key }))
              .filter((t, e, a) => a.findIndex((e) => e.key === t.key) === e);
            return e.length
              ? s.default.createElement(
                  s.default.Fragment,
                  null,
                  s.default.createElement('h2', { className: 'marketplace-card-type-heading' }, a('tabs.' + t.name)),
                  s.default.createElement(
                    'div',
                    {
                      className: 'marketplace-grid main-gridContainer-gridContainer main-gridContainer-fixedWidth',
                      'data-tab': this.CONFIG.activeTab,
                      'data-card-type': a('tabs.' + t.name),
                    },
                    e,
                  ),
                )
              : null;
          }),
          'Snippets' === this.CONFIG.activeTab
            ? s.default.createElement(
                g,
                { classes: ['marketplace-add-snippet-btn'], onClick: () => N('ADD_SNIPPET') },
                '+ ',
                a('grid.addCSS'),
              )
            : null,
          s.default.createElement(
            'footer',
            { className: 'marketplace-footer' },
            !this.state.endOfList &&
              (this.state.rest && 0 < this.state.cards.length
                ? s.default.createElement(Nr, { onClick: this.loadMore.bind(this) })
                : s.default.createElement(xr, null)),
          ),
          s.default.createElement(_r, {
            switchCallback: this.switchTo.bind(this),
            links: this.CONFIG.tabs,
            activeLink: this.CONFIG.activeTab,
          }),
        );
      }
    },
    Wr = qt()(a),
    T = t(b()),
    Me = class extends T.default.Component {
      state = { isInstalled: this.props.data.isInstalled(), html: `<p>${this.props.t('readmePage.loading')}</p>` };
      getReadmeHTML = async () =>
        fetch(this.props.data.readmeURL)
          .then((e) => {
            if (e.ok) return e.text();
            throw Spicetify.showNotification(`${this.props.t('readmePage.errorLoading')} (HTTP ${e.status})`, !0);
          })
          .then((e) => Ta(e, this.props.data.user, this.props.data.repo))
          .then((e) => (e || Spicetify.Platform.History.goBack(), e))
          .catch((e) => (console.error(e), Spicetify.Platform.History.goBack(), null));
      componentDidMount() {
        this.getReadmeHTML().then((e) => {
          null != e && this.setState({ html: e });
        });
      }
      componentDidUpdate() {
        const e = document.querySelector('#marketplace-readme')?.closest('main');
        if (e) {
          const t = setInterval(() => {
            document.querySelector('#marketplace-readme')
              ? ((e.style.overflowY = 'visible'), (e.style.overflowY = 'auto'))
              : (clearInterval(t), e.style.removeProperty('overflow-y'));
          }, 1e3);
        }
        document.querySelectorAll('#marketplace-readme img').forEach((e) => {
          e.addEventListener(
            'error',
            (e) => {
              var e = e.target,
                t = e.getAttribute('src'),
                t =
                  '/' === t?.charAt(0)
                    ? `https://raw.githubusercontent.com/${this.props.data.user}/${this.props.data.repo}/${this.props.data.branch}/` +
                      t?.slice(1)
                    : this.props.data.readmeURL.substring(0, this.props.data.readmeURL.lastIndexOf('/')) + '/' + t;
              e.setAttribute('src', t);
            },
            { once: !0 },
          );
        });
      }
      buttonContent() {
        return 'app' === this.props.data.type
          ? { icon: T.default.createElement(Br, null), text: this.props.t('github') }
          : this.state.isInstalled
            ? { icon: T.default.createElement(Dr, null), text: this.props.t('remove') }
            : { icon: T.default.createElement(zr, null), text: this.props.t('install') };
      }
      render() {
        var e =
          'control' !== JSON.parse(localStorage.getItem('spicetify-exp-features') || '{}').enableGlobalNavBar?.value &&
          !0;
        return T.default.createElement(
          'section',
          { className: 'contentSpacing' },
          T.default.createElement(
            'div',
            { className: 'marketplace-header', style: { marginTop: e ? '60px' : '0px' } },
            T.default.createElement(
              'div',
              { className: 'marketplace-header__left' },
              T.default.createElement('h1', null, this.props.title),
            ),
            T.default.createElement(
              'div',
              { className: 'marketplace-header__right' },
              T.default.createElement(
                g,
                {
                  classes: ['marketplace-header__button'],
                  onClick: (e) => {
                    e.preventDefault(),
                      this.props.data.install(),
                      this.setState({ isInstalled: !this.state.isInstalled });
                  },
                  label: this.buttonContent().text,
                },
                this.buttonContent().icon,
                ' ',
                this.buttonContent().text,
              ),
            ),
          ),
          '<p>Loading...</p>' === this.state.html
            ? T.default.createElement('footer', { className: 'marketplace-footer' }, T.default.createElement(xr, null))
            : T.default.createElement('div', {
                id: 'marketplace-readme',
                className: 'marketplace-readme__container',
                dangerouslySetInnerHTML: { __html: this.state.html },
              }),
        );
      }
    },
    Zr = qt()(Me),
    _e =
      (r
        .use(z)
        .use(Wt)
        .init({
          resources: ha,
          detection: { order: ['navigator', 'htmlTag'] },
          fallbackLng: 'en',
          interpolation: { escapeValue: !1 },
        }),
      class extends ze.default.Component {
        state = { count: 0, CONFIG: {} };
        CONFIG;
        constructor(e) {
          super(e);
          e = C(w.tabs, null);
          let t = [];
          try {
            if (((t = JSON.parse(e)), !Array.isArray(t))) throw new Error('Could not parse marketplace tabs key');
            if (0 === t.length) throw new Error('Empty marketplace tabs key');
            if (0 < t.filter((e) => !e).length) throw new Error('Falsey marketplace tabs key');
          } catch {
            (t = fa), localStorage.setItem(w.tabs, JSON.stringify(t));
          }
          let a = {},
            r = null;
          try {
            var n = C(w.themeInstalled, null);
            if (n) {
              var o = C(n, null);
              if (!o) throw new Error('No installed theme data');
              (a = o.schemes), (r = o.activeScheme);
            } else console.debug('No theme set as installed');
          } catch (e) {
            console.error(e);
          }
          (this.CONFIG = {
            visual: {
              stars: JSON.parse(C('marketplace:stars', !0)),
              tags: JSON.parse(C('marketplace:tags', !0)),
              showArchived: JSON.parse(C('marketplace:showArchived', !1)),
              hideInstalled: JSON.parse(C('marketplace:hideInstalled', !1)),
              colorShift: JSON.parse(C('marketplace:colorShift', !1)),
              themeDevTools: JSON.parse(C('marketplace:themeDevTools', !1)),
              albumArtBasedColors: JSON.parse(C('marketplace:albumArtBasedColors', !1)),
              albumArtBasedColorsMode: C('marketplace:albumArtBasedColorsMode') || 'monochrome-light',
              albumArtBasedColorsVibrancy: C('marketplace:albumArtBasedColorsVibrancy') || 'PROMINENT',
              type: JSON.parse(C('marketplace:type', !1)),
              followers: JSON.parse(C('marketplace:followers', !1)),
            },
            tabs: t,
            activeTab: C(w.activeTab, t[0]),
            theme: { activeThemeKey: C(w.themeInstalled, null), schemes: a, activeScheme: r },
            sort: C(w.sort, 'stars'),
          }),
            (this.CONFIG.activeTab && this.CONFIG.tabs.filter((e) => e.name === this.CONFIG.activeTab).length) ||
              (this.CONFIG.activeTab = this.CONFIG.tabs[0].name);
        }
        updateConfig = (e) => {
          (this.CONFIG = { ...e }), console.debug('updated config', this.CONFIG), this.setState({ CONFIG: { ...e } });
        };
        render() {
          var { location: e, replace: t } = Spicetify.Platform.History;
          return e.pathname === ga + '/readme'
            ? e.state?.data
              ? ze.default.createElement(Zr, { title: y('readmePage.title'), data: e.state.data })
              : (t(ga), null)
            : ze.default.createElement(Wr, {
                title: y('grid.spicetifyMarketplace'),
                CONFIG: this.CONFIG,
                updateAppConfig: this.updateConfig,
              });
        }
      }),
    Xr = qt()(_e),
    Yr = t(b());
  return (Pe = je), $(M({}, '__esModule', { value: !0 }), Pe);
})();
const render = () => marketplace.default();
