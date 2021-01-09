"use strict";
var __assign = (this && this.__assign) || function () {
    __assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return __assign.apply(this, arguments);
};
var __spreadArrays = (this && this.__spreadArrays) || function () {
    for (var s = 0, i = 0, il = arguments.length; i < il; i++) s += arguments[i].length;
    for (var r = Array(s), k = 0, i = 0; i < il; i++)
        for (var a = arguments[i], j = 0, jl = a.length; j < jl; j++, k++)
            r[k] = a[j];
    return r;
};
exports.__esModule = true;
var react_1 = require("react");
var react_router_dom_1 = require("react-router-dom");
var axios_1 = require("axios");
var Common = require("../constants/common");
var initSearchParams = {
    page: Common.FIRST_PAGE,
    sort: Common.SORT_UPDATED_AT,
    order: Common.ORDER_DESC,
    tags: '',
    locations: '',
    contracts: '',
    positions: '',
    industries: '',
    keyword: ''
};
var initProjectsData = {
    status: 204,
    result: 'NO CONTENT',
    pjtCount: 0,
    currentPage: Common.FIRST_PAGE,
    sort: Common.SORT_UPDATED_AT,
    order: Common.ORDER_DESC,
    totalPjtCount: 0,
    totalPages: 1,
    pjtList: [],
    searchParams: initSearchParams
};
var SORT_LIST = [
    {
        title: Common.TITLE_UPDATED_AT,
        sort: Common.SORT_UPDATED_AT
    },
    {
        title: Common.TITLE_PRICE,
        sort: Common.SORT_PRICE
    },
];
var ORDER_LIST = [
    {
        title: Common.TITLE_DESC,
        order: Common.ORDER_DESC
    },
    {
        title: Common.TITLE_ASC,
        order: Common.ORDER_ASC
    },
];
var Projects = function () {
    var _a = react_1.useState(initSearchParams), searchParams = _a[0], setSearchParams = _a[1];
    var _b = react_1.useState(initProjectsData), projectsData = _b[0], setProjectsData = _b[1];
    var location = react_router_dom_1.useLocation();
    var history = react_router_dom_1.useHistory();
    react_1.useEffect(function () {
        var params = searchParams;
        if (location.search) {
            var page_1 = searchParams.page;
            var sort_1 = searchParams.sort;
            var order_1 = searchParams.order;
            var tags_1 = searchParams.tags;
            var locations_1 = searchParams.locations;
            var contracts_1 = searchParams.contracts;
            var positions_1 = searchParams.positions;
            var industries_1 = searchParams.industries;
            var keyword_1 = searchParams.keyword;
            var paramsList = location.search.slice(1).split('&');
            paramsList.map(function (paramBase) {
                var paramsBase = paramBase.split('=');
                var paramTitle = paramsBase[0];
                var paramItems = paramsBase[1];
                switch (paramTitle) {
                    case 'page':
                        return page_1 = Number(paramItems);
                    case 'sort':
                        return sort_1 = paramItems;
                    case 'order':
                        return order_1 = paramItems;
                    case 'tags':
                        return tags_1 = paramItems;
                    case 'locations':
                        return locations_1 = paramItems;
                    case 'contracts':
                        return contracts_1 = paramItems;
                    case 'positions':
                        return positions_1 = paramItems;
                    case 'industries':
                        return industries_1 = paramItems;
                    case 'keyword':
                        return keyword_1 = paramItems;
                    default:
                        return null;
                }
            });
            params = {
                page: page_1,
                sort: sort_1,
                order: order_1,
                tags: tags_1,
                locations: locations_1,
                contracts: contracts_1,
                positions: positions_1,
                industries: industries_1,
                keyword: keyword_1
            };
        }
        axios_1["default"].get(Common.API_ENDPOINT + "search/index", {
            params: params
        })
            .then(function (res) {
            // FIXME 案件検索ヒット数が0の場合に以下の条件に入る
            if (res.data.totalPjtCount === 0) {
                console.log('NO CONTENT');
                react_1["default"].createElement(react_router_dom_1.Redirect, { to: '/' });
            }
            setProjectsData(res.data);
        })["catch"](function (res) {
            console.log(res);
        });
    }, [searchParams]);
    window.scrollTo(0, 0);
    return (react_1["default"].createElement("div", null,
        react_1["default"].createElement("section", { className: 'pjt-list' },
            react_1["default"].createElement("h2", { className: 'component-title' }, "\u6848\u4EF6\u4E00\u89A7"),
            react_1["default"].createElement("h4", null,
                "\u73FE\u5728\u306E\u30DA\u30FC\u30B8\uFF08\u30C6\u30B9\u30C8\u7528\uFF09\uFF1A",
                projectsData.currentPage),
            react_1["default"].createElement("div", { className: 'sort-option-btn-container' },
                react_1["default"].createElement("div", { className: 'sort-btn-box' }, SORT_LIST.map(function (sortHash, index) {
                    return (react_1["default"].createElement(react_1["default"].Fragment, null,
                        react_1["default"].createElement(react_router_dom_1.Link, { to: handleLocationSearch(projectsData.searchParams.tags, projectsData.searchParams.locations, projectsData.searchParams.contracts, projectsData.searchParams.positions, projectsData.searchParams.industries, projectsData.searchParams.keyword, Common.FIRST_PAGE, sortHash.sort, projectsData.searchParams.order), onClick: function (e) {
                                history.push(handleLocationSearch(projectsData.searchParams.tags, projectsData.searchParams.locations, projectsData.searchParams.contracts, projectsData.searchParams.positions, projectsData.searchParams.industries, projectsData.searchParams.keyword, Common.FIRST_PAGE, sortHash.sort, projectsData.searchParams.order));
                                setSearchParams(__assign(__assign({}, searchParams), { page: Common.FIRST_PAGE, sort: sortHash.sort }));
                            }, key: "sortKey" + index }, sortHash.title)));
                })),
                react_1["default"].createElement("div", { className: 'order-btn-box' }, ORDER_LIST.map(function (orderHash, index) {
                    return (react_1["default"].createElement(react_1["default"].Fragment, null,
                        react_1["default"].createElement(react_router_dom_1.Link, { to: handleLocationSearch(projectsData.searchParams.tags, projectsData.searchParams.locations, projectsData.searchParams.contracts, projectsData.searchParams.positions, projectsData.searchParams.industries, projectsData.searchParams.keyword, Common.FIRST_PAGE, projectsData.searchParams.sort, orderHash.order), onClick: function (e) {
                                history.push(handleLocationSearch(projectsData.searchParams.tags, projectsData.searchParams.locations, projectsData.searchParams.contracts, projectsData.searchParams.positions, projectsData.searchParams.industries, projectsData.searchParams.keyword, Common.FIRST_PAGE, projectsData.searchParams.sort, orderHash.order));
                                setSearchParams(__assign(__assign({}, searchParams), { page: Common.FIRST_PAGE, order: orderHash.order }));
                            }, key: "orderKey" + index }, orderHash.title)));
                }))),
            react_1["default"].createElement("ul", null, projectsData.pjtList.map(function (pjt, indexPjt) {
                var minPriceStr = pjt.min_price === 0 || null ? '' : String(pjt.min_price.toLocaleString());
                var maxPriceStr = String(pjt.max_price.toLocaleString());
                return (react_1["default"].createElement("li", { className: 'pjt-box', key: "pjt" + indexPjt },
                    react_1["default"].createElement(react_router_dom_1.Link, { to: "/project/" + pjt.id, className: 'pjt-link', key: "pjtLink" + indexPjt },
                        react_1["default"].createElement("h2", { className: 'pjt-title' }, pjt.title)),
                    react_1["default"].createElement("div", { className: 'pjt-summary' },
                        react_1["default"].createElement("table", null,
                            react_1["default"].createElement("tr", null,
                                react_1["default"].createElement("th", { className: 'pjt-price' }, "\u5358\u4FA1\uFF1A"),
                                react_1["default"].createElement("td", null,
                                    minPriceStr,
                                    "~",
                                    maxPriceStr,
                                    pjt.price_unit),
                                react_1["default"].createElement("th", { className: 'pjt-location' }, "\u52E4\u52D9\u5730\uFF1A"),
                                react_1["default"].createElement("td", null, pjt.location_name)),
                            react_1["default"].createElement("tr", null,
                                react_1["default"].createElement("th", null, "\u30BF\u30B0\uFF1A"),
                                react_1["default"].createElement("td", null,
                                    react_1["default"].createElement("ul", null, tagList(pjt))))),
                        react_1["default"].createElement("ul", null,
                            react_1["default"].createElement("li", { className: "pjt-tags" + indexPjt, key: "" },
                                react_1["default"].createElement("li", { className: 'pjt-updated-at', key: "pjtUpdatedAt" + indexPjt },
                                    "\u66F4\u65B0\u65E5\uFF1A",
                                    dateFormat(pjt.updated_at, 'YYYY年MM月DD日'))))),
                    react_1["default"].createElement("h3", { className: 'pjt-company' },
                        "From ",
                        pjt.company)));
            })),
            react_1["default"].createElement("div", { className: 'paging-btn-container' }, __spreadArrays(Array(projectsData.totalPages)).map(function (_, index) {
                var page = index + 1;
                return (react_1["default"].createElement(react_1["default"].Fragment, null,
                    react_1["default"].createElement(react_router_dom_1.Link, { to: handleLocationSearch(projectsData.searchParams.tags, projectsData.searchParams.locations, projectsData.searchParams.contracts, projectsData.searchParams.positions, projectsData.searchParams.industries, projectsData.searchParams.keyword, page, projectsData.searchParams.sort, projectsData.searchParams.order), onClick: function (e) {
                            history.push(handleLocationSearch(projectsData.searchParams.tags, projectsData.searchParams.locations, projectsData.searchParams.contracts, projectsData.searchParams.positions, projectsData.searchParams.industries, projectsData.searchParams.keyword, page, projectsData.searchParams.sort, projectsData.searchParams.order));
                            setSearchParams(__assign(__assign({}, searchParams), { page: page }));
                        } }, page)));
            })))));
};
// URL作成メソッド
var handleLocationSearch = function (tags, locations, contracts, positions, industries, keyword, page, sort, order) {
    var locationSearch = '/projects?';
    locationSearch = locationSearch.concat("tags=" + tags);
    locationSearch = locationSearch.concat("&locations=" + locations);
    locationSearch = locationSearch.concat("&contracts=" + contracts);
    locationSearch = locationSearch.concat("&positions=" + positions);
    locationSearch = locationSearch.concat("&industries=" + industries);
    locationSearch = locationSearch.concat("&keyword=" + keyword);
    locationSearch = locationSearch.concat("&page=" + page);
    locationSearch = locationSearch.concat("&sort=" + sort);
    locationSearch = locationSearch.concat("&order=" + order);
    return locationSearch;
};
// タグ一覧
var tagList = function (pjt) {
    var tagNameList = pjt.tag_name_list;
    if (tagNameList !== null) {
        return (react_1["default"].createElement(react_1["default"].Fragment, null, tagNameList.map(function (tag_name, indexTagName) {
            return (react_1["default"].createElement("li", { className: 'pjt-tag-name', key: "pjtTagName" + indexTagName }, tag_name));
        })));
    }
};
// 日付フォーマットメソッド
var dateFormat = function (dateParam, format) {
    var date = new Date(dateParam);
    var year = date.getFullYear();
    var month = date.getMonth() + 1;
    var day = date.getDate();
    format = format.replace(/YYYY/, year.toString());
    format = format.replace(/MM/, month.toString());
    format = format.replace(/DD/, day.toString());
    return format;
};
exports["default"] = Projects;
