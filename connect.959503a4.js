var u = Object.defineProperty;
var b = (o, e, t) => e in o ? u(o, e, {
    enumerable: !0,
    configurable: !0,
    writable: !0,
    value: t
}) : o[e] = t;
var i = (o, e, t) => (b(o, typeof e != "symbol" ? e + "" : e, t),
t);
import {g as h, a as A, A as E, b as y, L, c as k, p as n} from "./segment-script.d10ebbaa.js";
import {R as d, j as C, c as D} from "./vendor.b4636db4.js";
class O {
    constructor(e) {
        i(this, "ApiClient");
        i(this, "root");
        this.ApiClient = e,
        this.root = h()
    }
    async create(e) {
        var t, r, l, c, s, p;
        try {
            const a = new this.ApiClient(e)
              , w = await a.initializeConnect()
              , g = await A(a, e);
            d.render(C(E, {
                children: C(y, {
                    apiClient: a,
                    config: e,
                    prefilledData: g,
                    connectTokenData: w
                })
            }), this.root),
            (t = window.Localize) == null || t.initialize({
                blockedClasses: ["notranslate"],
                blockedIds: ["utility-select"],
                disableWidget: !0,
                key: L,
                rememberLanguage: !0
            }),
            (c = window.Localize) == null || c.setLanguage((l = (r = e._experimental) == null ? void 0 : r.language) != null ? l : "en"),
            (p = (s = e.callbacks) == null ? void 0 : s.onOpen) == null || p.call(s)
        } catch (a) {
            throw console.error(a),
            new Error("Error rendering Connect.")
        }
    }
    close() {
        d.unmountComponentAtNode(this.root)
    }
}
const m = new O(k);
window.addEventListener("message", async o => {
    const {data: e} = o;
    if (e.type === "open") {
        const t = D(e.config, {
            callbacks: {
                onOpen: n("onOpen"),
                onClose: n("onClose"),
                onError: n("onError"),
                onCredentialsSubmitted: n("onCredentialsSubmitted")
            }
        });
        try {
            await m.create(t),
            n("openComplete")()
        } catch (r) {
            n("onError")({
                error: r
            })
        }
    } else
        e.type === "close" && m.close()
}
);
//# sourceMappingURL=connect.959503a4.js.map
