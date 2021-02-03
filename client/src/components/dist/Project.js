"use strict";
exports.__esModule = true;
var react_1 = require("react");
var react_router_dom_1 = require("react-router-dom");
var axios_1 = require("axios");
var Common = require("../constants/common");
var currentDate = new Date();
var initProjectData = {
    status: 204,
    result: 'NO CONTENT',
    project: {
        id: 0,
        title: '',
        description: '',
        company_id: 0,
        company: '',
        url: '',
        affiliate_url: '',
        required_skills: '',
        other_skills: '',
        environment: '',
        weekly_attendance: 0,
        min_operation_unit: 0,
        max_operation_unit: 0,
        operation_unit_id: 0,
        operation_unit: '',
        min_price: 0,
        max_price: 0,
        price_unit_id: 0,
        price_unit: '',
        location_id: 0,
        contract_id: 0,
        display_flg: '',
        deleted_flg: '',
        deleted_at: currentDate,
        created_at: currentDate,
        updated_at: currentDate,
        location_name: '',
        contract_name: '',
        position_name_list: [],
        position_name_search_list: [],
        industry_name_list: [],
        industry_name_search_list: [],
        tag_name_list: [],
        tag_name_search_list: []
    }
};
var Project = function () {
    var pjtId = react_router_dom_1.useParams().pjtId;
    var _a = react_1.useState(initProjectData), projectData = _a[0], setProjectData = _a[1];
    react_1.useEffect(function () {
        var projectId = {
            pjtId: Number(pjtId)
        };
        axios_1["default"].get(Common.API_ENDPOINT + "search/show", {
            params: projectId
        })
            .then(function (res) {
            setProjectData(res.data);
        })["catch"](function (res) {
            console.log(res);
        });
    }, [pjtId]);
    window.scrollTo(0, 0);
    return (react_1["default"].createElement("div", { className: 'project' },
        react_1["default"].createElement("section", { className: 'pjt-box' },
            react_1["default"].createElement("h1", { className: 'pjt-title' }, projectData.project.title),
            react_1["default"].createElement("div", { className: 'pjt-table-container' },
                react_1["default"].createElement("table", { className: 'pjt-summary-table' }, Common.PROJECT_SUMMARY_TITLE.map(function (title) {
                    return pjtSummary(title, projectData.project);
                })),
                react_1["default"].createElement("table", { className: 'pjt-tags-table' }, Common.PROJECT_TAGS_TITLE.map(function (title) {
                    return pjtTags(title, projectData.project);
                }))),
            affiliateUrl(projectData.project.affiliate_url),
            react_1["default"].createElement("ul", null, Common.PROJECT_DETAIL_TITLE.map(function (title, index) {
                return pjtDetail(title, projectData.project, index);
            })),
            affiliateUrl(projectData.project.affiliate_url))));
};
// for pjt-summary-table
var pjtSummary = function (title, project) {
    var value = '';
    switch (title) {
        case '勤務地':
            value = project.location_name;
            break;
        case '単価':
            var minPrice = project.min_price;
            var maxPrice = project.max_price;
            var minPriceStr = minPrice === 0 || minPrice === null ? '' : String(minPrice.toLocaleString());
            var maxPriceStr = maxPrice === 0 || maxPrice === null ? '' : String(maxPrice.toLocaleString());
            if (minPriceStr !== '' || maxPriceStr !== '') {
                value = minPriceStr + "~" + maxPriceStr + project.price_unit;
            }
            else {
                value = '';
            }
            break;
        case '稼働時間':
            var minOperation = project.min_operation_unit;
            var maxOperation = project.max_operation_unit;
            var minOperationStr = minOperation === 0 || minOperation === null ? '' : minOperation.toString();
            var maxOperationStr = maxOperation === 0 || maxOperation === null ? '' : maxOperation.toString();
            if (minOperationStr !== '' || maxOperationStr !== '') {
                value = minOperationStr + "~" + maxOperationStr + project.operation_unit;
            }
            else {
                value = '';
            }
            break;
        case '契約形態':
            value = project.contract_name;
            break;
        case '週稼働日数':
            var weeklyAttendance = project.weekly_attendance;
            value = weeklyAttendance === 0 || weeklyAttendance === null ? '' : String(project.weekly_attendance);
            break;
        default:
            break;
    }
    if (value !== null && value !== '') {
        return (react_1["default"].createElement("tr", null,
            react_1["default"].createElement("th", null,
                title,
                "\uFF1A"),
            react_1["default"].createElement("td", null, value)));
    }
    else {
        return null;
    }
};
var pjtTags = function (title, project) {
    var valueList = [];
    switch (title) {
        case 'ポジション':
            valueList = project.position_name_list;
            break;
        case '業界':
            valueList = project.industry_name_list;
            break;
        case 'タグ':
            valueList = project.tag_name_list;
            break;
        default:
            break;
    }
    if (valueList !== null) {
        return (react_1["default"].createElement("tr", null,
            react_1["default"].createElement("th", null,
                title,
                "\uFF1A"),
            react_1["default"].createElement("td", null, valueList.map(function (value) {
                return (react_1["default"].createElement("div", { className: 'tag' }, value));
            }))));
    }
    else {
        return null;
    }
};
// 案件詳細
var pjtDetail = function (title, project, index) {
    var value = '';
    switch (title) {
        case '案件内容':
            value = project.description;
            break;
        case '必須スキル':
            value = project.required_skills;
            break;
        case '歓迎スキル':
            value = project.other_skills;
            break;
        case '開発環境':
            value = project.environment;
            break;
        default:
            break;
    }
    if (value !== null && value !== '') {
        return (react_1["default"].createElement("li", { className: 'pjt-detail-li', key: "pjtLi" + index },
            react_1["default"].createElement("h3", { className: 'pjt-detail-title' }, title),
            react_1["default"].createElement("p", { className: 'pjt-detail-value' }, value)));
    }
    else {
        return null;
    }
};
// アフィリエイトリンク
var affiliateUrl = function (url) {
    return (react_1["default"].createElement("div", { className: 'affiliate-link' },
        react_1["default"].createElement("a", { href: url, target: '_blank', rel: 'noreferrer' }, Common.AFFILIATE_LINK_TITLE)));
};
exports["default"] = Project;
