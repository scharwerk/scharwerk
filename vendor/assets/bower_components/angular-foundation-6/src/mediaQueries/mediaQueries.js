angular.module('mm.foundation.mediaQueries', [])
.factory('matchMedia', ($document, $window) => {
    'ngInject';
    // MatchMedia for IE <= 9
    return $window.matchMedia || (function(doc, undefined) {
        let bool;
        const docElem = doc.documentElement;
        const refNode = docElem.firstElementChild || docElem.firstChild;
        // fakeBody required for <FF4 when executed in <head>
        const fakeBody = doc.createElement('body');
        const div = doc.createElement('div');

        div.id = 'mq-test-1';
        div.style.cssText = 'position:absolute;top:-100em';
        fakeBody.style.background = 'none';
        fakeBody.appendChild(div);

        return (q) => {
            div.innerHTML = `&shy;<style media="${q}"> #mq-test-1 { width: 42px; }</style>`;
            docElem.insertBefore(fakeBody, refNode);
            bool = div.offsetWidth === 42;
            docElem.removeChild(fakeBody);
            return {
                matches: bool,
                media: q,
            };
        };
    }($document[0]));
})
.factory('mediaQueries', ($document, matchMedia) => {
    'ngInject';

    // Thank you: https://github.com/sindresorhus/query-string
    function parseStyleToObject(str) {
        let styleObject = {};

        if (typeof str !== 'string') {
            return styleObject;
        }

        str = str.trim().slice(1, -1); // browsers re-quote string style values

        if (!str) {
            return styleObject;
        }

        styleObject = str.split('&').reduce((ret, param) => {
            const parts = param.replace(/\+/g, ' ').split('=');
            let key = parts[0];
            let val = parts[1];
            key = decodeURIComponent(key);

            // missing `=` should be `null`:
            // http://w3.org/TR/2012/WD-url-20120524/#collect-url-parameters
            val = val === undefined ? null : decodeURIComponent(val);

            if (!ret.hasOwnProperty(key)) {
                ret[key] = val;
            } else if (Array.isArray(ret[key])) {
                ret[key].push(val);
            } else {
                ret[key] = [ret[key], val];
            }
            return ret;
        }, {});

        return styleObject;
    }

    const head = angular.element($document[0].querySelector('head'));
    head.append('<meta class="foundation-mq" />');
    const extractedStyles =
        getComputedStyle(head[0].querySelector('meta.foundation-mq')).fontFamily;
    const namedQueries = parseStyleToObject(extractedStyles);
    const queries = [];

    for (let key in namedQueries) {
        queries.push({
            name: key,
            value: `only screen and (min-width: ${namedQueries[key]})`,
        });
    }

    // Gets the media query of a breakpoint.
    function get(size) {
        for (let i in this.queries) {
            const query = this.queries[i];
            if (size === query.name) return query.value;
        }

        return null;
    }

    function atLeast(size) {
        const query = get(size);

        if (query) {
            return window.matchMedia(query).matches;
        }
        return false;
    }

    // Gets the current breakpoint name by testing every breakpoint and returning the last one to match (the biggest one).
    function getCurrentSize() {
        let matched;

        for (let i = 0; i < queries.length; i++) {
            const query = queries[i];

            if (matchMedia(query.value).matches) {
                matched = query;
            }
        }

        if (typeof matched === 'object') {
            return matched.name;
        }
        return matched;
    }

    const iPhoneSniff = () => /iP(ad|hone|od).*OS/.test(window.navigator.userAgent);
    const androidSniff = () => /Android/.test(window.navigator.userAgent);

    return {
        getCurrentSize,
        atLeast,
        mobileSniff: () => iPhoneSniff() || androidSniff(),
    };
});
