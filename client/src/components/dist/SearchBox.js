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
exports.__esModule = true;
var react_1 = require("react");
var axios_1 = require("axios");
var Common = require("../constants/common");
var react_router_dom_1 = require("react-router-dom");
var initCheckBoxItem = {
    status: 204,
    result: 'NO CONTENT',
    tagList: [],
    locationList: [],
    contractList: [],
    positionList: [],
    industryList: []
};
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
var SearchBox = function () {
    var _a = react_1.useState(initCheckBoxItem), checkBoxItemList = _a[0], setCheckBoxItemList = _a[1];
    var _b = react_1.useState(initSearchParams), searchParams = _b[0], setSearchParams = _b[1];
    react_1.useEffect(function () {
        axios_1["default"].get(Common.API_ENDPOINT + "search/checkbox-items")
            .then(function (res) {
            setCheckBoxItemList(res.data);
        })["catch"](function (res) {
            console.log(res);
        });
    }, [checkBoxItemList.status]);
    var history = react_router_dom_1.useHistory();
    return (react_1["default"].createElement(react_1["default"].Fragment, null,
        react_1["default"].createElement("h2", null, "\u6848\u4EF6\u3092\u63A2\u3059"),
        react_1["default"].createElement("form", { className: 'search-form' },
            react_1["default"].createElement("div", { className: 'sort-option-checkbox-container' },
                react_1["default"].createElement("div", { className: 'sort-checkbox-box' }, SORT_LIST.map(function (sortHash, index) {
                    var checked = searchParams.sort === sortHash.sort ? true : false;
                    return (react_1["default"].createElement(react_1["default"].Fragment, null,
                        react_1["default"].createElement("label", { htmlFor: 'pjt-sort-input', key: "sortLabel" + index },
                            react_1["default"].createElement("input", { className: 'pjt-sort-input', type: 'radio', checked: checked, value: sortHash.sort, name: 'sort', id: 'pjt-sort-input', onChange: function (e) {
                                    setSearchParams(__assign(__assign({}, searchParams), { sort: e.target.value }));
                                }, key: "sortInput" + index }),
                            sortHash.title)));
                })),
                react_1["default"].createElement("div", { className: 'order-checkbox-box' }, ORDER_LIST.map(function (orderHash, index) {
                    var checked = searchParams.order === orderHash.order ? true : false;
                    return (react_1["default"].createElement(react_1["default"].Fragment, null,
                        react_1["default"].createElement("label", { htmlFor: 'pjt-order-input', key: "orderLabel" + index },
                            react_1["default"].createElement("input", { className: 'pjt-order-input', type: 'radio', checked: checked, value: orderHash.order, name: 'order', id: 'pjt-order-input', onChange: function (e) {
                                    setSearchParams(__assign(__assign({}, searchParams), { order: e.target.value }));
                                }, key: "orderInput" + index }),
                            orderHash.title)));
                }))),
            react_1["default"].createElement("div", { className: 'search-tab search-tag-tab' },
                react_1["default"].createElement("h3", null, "\u30BF\u30B0\u3067\u63A2\u3059"),
                checkBoxItemList.tagList.map(function (tag, index) {
                    return (react_1["default"].createElement("label", { htmlFor: 'pjt-tag-input', key: "tagLabelKey" + index },
                        react_1["default"].createElement("input", { type: 'checkbox', value: tag.tag_name_search, name: 'tags', id: 'pjt-tag-input', onChange: function (e) {
                                var tags = searchParams.tags;
                                var tagList = tags === '' ? [] : tags.split(',');
                                if (!tagList.includes(e.target.value)) {
                                    tagList.push(e.target.value);
                                    tags = tagList.join(',');
                                }
                                setSearchParams(__assign(__assign({}, searchParams), { tags: tags }));
                            }, key: "tagInputKey" + index }),
                        tag.tag_name));
                })),
            react_1["default"].createElement("div", { className: 'search-tab search-location-tab' },
                react_1["default"].createElement("h3", null, "\u52E4\u52D9\u5730\u3067\u63A2\u3059"),
                checkBoxItemList.locationList.map(function (location, index) {
                    return (react_1["default"].createElement("label", { htmlFor: 'pjt-location-input', key: "locationLabelKey" + index },
                        react_1["default"].createElement("input", { type: 'checkbox', value: location.location_name, name: 'locations', id: 'pjt-location-input', onChange: function (e) {
                                var locations = searchParams.locations;
                                var locationList = locations === '' ? [] : locations.split(',');
                                if (!locationList.includes(e.target.value)) {
                                    locationList.push(e.target.value);
                                    locations = locationList.join(',');
                                }
                                setSearchParams(__assign(__assign({}, searchParams), { locations: locations }));
                            }, key: "locationInputKey" + index }),
                        location.location_name));
                })),
            react_1["default"].createElement("div", { className: 'search-tab search-contract-tab' },
                react_1["default"].createElement("h3", null, "\u5951\u7D04\u5F62\u614B\u3067\u63A2\u3059"),
                checkBoxItemList.contractList.map(function (contract, index) {
                    return (react_1["default"].createElement("label", { htmlFor: 'pjt-contract-input', key: "contractLabelKey" + index },
                        react_1["default"].createElement("input", { type: 'checkbox', value: contract.contract_name, name: 'contracts', id: 'pjt-contract-input', onChange: function (e) {
                                var contracts = searchParams.contracts;
                                var contractList = contracts === '' ? [] : contracts.split(',');
                                if (!contractList.includes(e.target.value)) {
                                    contractList.push(e.target.value);
                                    contracts = contractList.join(',');
                                }
                                setSearchParams(__assign(__assign({}, searchParams), { contracts: contracts }));
                            }, key: "contractInputKey" + index }),
                        contract.contract_name));
                })),
            react_1["default"].createElement("div", { className: 'search-tab search-position-tab' },
                react_1["default"].createElement("h3", null, "\u30DD\u30B8\u30B7\u30E7\u30F3\u3067\u63A2\u3059"),
                checkBoxItemList.positionList.map(function (position, index) {
                    return (react_1["default"].createElement("label", { htmlFor: 'pjt-position-input', key: "positionLabelKey" + index },
                        react_1["default"].createElement("input", { type: 'checkbox', value: position.position_name_search, name: 'positions', id: 'pjt-position-input', onChange: function (e) {
                                var positions = searchParams.positions;
                                var positionList = positions === '' ? [] : positions.split(',');
                                if (!positionList.includes(e.target.value)) {
                                    positionList.push(e.target.value);
                                    positions = positionList.join(',');
                                }
                                setSearchParams(__assign(__assign({}, searchParams), { positions: positions }));
                            }, key: "positionInputKey" + index }),
                        position.position_name));
                })),
            react_1["default"].createElement("div", { className: 'search-tab search-industry-tab' },
                react_1["default"].createElement("h3", null, "\u696D\u754C\u3067\u63A2\u3059"),
                checkBoxItemList.industryList.map(function (industry, index) {
                    return (react_1["default"].createElement("label", { htmlFor: 'pjt-industry-input', key: "industryLabelKey" + index },
                        react_1["default"].createElement("input", { type: 'checkbox', value: industry.industry_name_search, name: 'industries', id: 'pjt-industry-input', onChange: function (e) {
                                var industries = searchParams.industries;
                                var industryList = industries === '' ? [] : industries.split(',');
                                if (!industryList.includes(e.target.value)) {
                                    industryList.push(e.target.value);
                                    industries = industryList.join(',');
                                }
                                setSearchParams(__assign(__assign({}, searchParams), { industries: industries }));
                            }, key: "industryInputKey" + index }),
                        industry.industry_name));
                })),
            react_1["default"].createElement(react_router_dom_1.Link, { to: handleLocationSearch(searchParams.tags, searchParams.locations, searchParams.contracts, searchParams.positions, searchParams.industries, searchParams.keyword, searchParams.sort, searchParams.order), onClick: function () { return history.push(handleLocationSearch(searchParams.tags, searchParams.locations, searchParams.contracts, searchParams.positions, searchParams.industries, searchParams.keyword, searchParams.sort, searchParams.order)); } }, "\u691C\u7D22"))));
};
var handleLocationSearch = function (tags, locations, contracts, positions, industries, keyword, sort, order) {
    var locationSearch = '/projects?';
    locationSearch = locationSearch.concat("tags=" + tags);
    locationSearch = locationSearch.concat("&locations=" + locations);
    locationSearch = locationSearch.concat("&contracts=" + contracts);
    locationSearch = locationSearch.concat("&positions=" + positions);
    locationSearch = locationSearch.concat("&industries=" + industries);
    locationSearch = locationSearch.concat("&keyword=" + keyword);
    locationSearch = locationSearch.concat("&page=" + Common.FIRST_PAGE);
    locationSearch = locationSearch.concat("&sort=" + sort);
    locationSearch = locationSearch.concat("&order=" + order);
    return locationSearch;
};
exports["default"] = SearchBox;
