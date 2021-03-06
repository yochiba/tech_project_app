"use strict";
exports.__esModule = true;
var react_1 = require("react");
var react_router_dom_1 = require("react-router-dom");
require("./App.scss");
var Navigation_1 = require("./components/Navigation");
var Home_1 = require("./components/Home");
var Projects_1 = require("./components/Projects");
var Project_1 = require("./components/Project");
var Common = require("./constants/common");
var react_helmet_1 = require("react-helmet");
var App = function () {
    return (react_1["default"].createElement("div", { className: 'App' },
        react_1["default"].createElement(react_helmet_1.Helmet, null,
            react_1["default"].createElement("meta", { charSet: 'utf-8' }),
            react_1["default"].createElement("title", null, Common.WEBSITE_NAME),
            react_1["default"].createElement("link", { rel: 'canonical', href: '' }),
            react_1["default"].createElement("meta", { name: 'description', content: 'Description for techies guild' })),
        react_1["default"].createElement(react_router_dom_1.BrowserRouter, null,
            react_1["default"].createElement(Navigation_1["default"], null),
            react_1["default"].createElement(react_router_dom_1.Switch, null,
                react_1["default"].createElement(react_router_dom_1.Route, { exact: true, path: '/', component: Home_1["default"] }),
                react_1["default"].createElement(react_router_dom_1.Route, { exact: true, path: '/projects', component: Projects_1["default"] }),
                react_1["default"].createElement(react_router_dom_1.Route, { exact: true, path: '/project/:pjtId', component: Project_1["default"] })))));
};
exports["default"] = App;
