/* =============================================================
 * pgGrid v0.1.0
 * https://github.com/JSIStudios/PageableControls
 * =============================================================
 * Copyright 2014 JSI Studios, LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */


/*================================================================
 *====== MODIFIED FROM THE ORIGINAL TO SUPPORT BOOTSTRAP 3 AND
 *====== TO ALLOW OVERRIDING AN EXISTING PGGRID ON AN OBJECT
 *============================================================== */


(function($) {
    var PGGrid = function(element, options) {
        var that = this;
        this.$element = $(element);
        this.options = $.extend({}, $.fn.pgGrid.defaults, options);
        this.item = this.options.item;
        this.dataModel = this.options.dataModel;
        this.childRowProperty = this.options.childRowProperty;
        this.expandedRowIds = new Array();
        this.sortColumn = this.options.sortColumn;
        this.sortDirection = this.options.sortDirection;
        this.url = this.options.url;
        this.dataTotalIndex = this.options.dataTotalIndex;
        this.dataItemIndex = this.options.dataItemIndex;
        this.padLeft = this.options.padLeft;
        this.itemIdProperty = this.options.itemIdProperty;
        this.getData = this.options.getData || this.getData;
        this.process = this.options.process || this.process;
        this.render = this.options.render || this.render;
        this.buildFooter = this.options.buildFooter || this.buildFooter;
        this.onSuccess = this.options.onSuccess || function() {
            return;
        };
        this.onError = this.options.onError || function() {
            return;
        };
        this.buildQueryObject = this.options.buildQueryObject || this.buildQueryObject;
        this.$grid = $('<table class="pgGrid"><thead><tr></tr></thead><tbody></tbody><tfoot><tr><td></td></tr></tfoot></table>');
        this.$title = $(this.options.title);
        this.$initLoader = $(this.options.initLoader);
        this.$header = this.$grid.find("thead");
        this.$body = this.$grid.find("tbody");
        this.$footer = this.$grid.find("tfoot");
        this.$footerRow = this.$footer.find("td:first").attr("colspan", this.dataModel.length);
        this.pager = this.options.pager || new Pager({});
        $(this.pager).on("onRefresh", function(event, data) {
            that.refresh(data.currentPage, data.pageSize, function(d) {
                data.onComplete(d[that.dataTotalIndex]);
            });
        });
        this.$grid.addClass(this.options.gridClass);
        this.$element.append(this.$title);
        this.$element.append(this.$initLoader);
        this.$initLoader.show();
        this.buildHeader();
        this.buildFooter();
        this.hide();
        this.$element.append(this.$grid);
        this.pager.getPage();
    };
    PGGrid.prototype = {
        constructor: PGGrid,
        hide: function() {
            this.$grid.hide();
        },
        show: function() {
            this.$grid.show();
        },
        refresh: function(page, pageSize, onComplete) {
            var that = this;
            var process = $.proxy(this.process, this);
            this.getData(page, pageSize, this.sortColumn, this.sortDirection, function(data, textStatus, jqXHR) {
                that.onSuccess(data, textStatus, jqXHR);
                process(data);
                that.show();
                if (onComplete) onComplete(data);
                that.$initLoader.hide();
            }, this.onError);
        },
        getData: function(page, pageSize, sortCol, sortDir, onSuccess, onFail) {
            $.get(this.url, this.buildQueryObject(page, pageSize, sortCol, sortDir), onSuccess).fail(onFail);
        },
        buildQueryObject: function(page, pageSize, sortCol, sortDir) {
            return {
                page: page,
                limit: pageSize,
                sort_column: sortCol,
                sort_direction: sortDir
            };
        },
        process: function(data) {
            if (!data[this.dataItemIndex].length) {
                return this.hide();
            }
            return this.render(data);
        },
        render: function(data) {
            this.buildBody(data);
            return this;
        },
        buildBody: function(data) {
            this.$body.empty();
            for (var i in data[this.dataItemIndex]) {
                this.buildRow(data[this.dataItemIndex][i], 0);
            }
        },
        buildRow: function(item, childLevel, parentId) {
            var that = this;
            var id = item[this.itemIdProperty];
            var row = $("<tr></tr>").attr("id", id).on("mouseEnter", "tbody tr", $.proxy(this.mouseEnter, this)).on("mouseLeave", "tbody tr", $.proxy(this.mouseLeave, this));
            if (childLevel > 0) {
                if ($.inArray(parentId, this.expandedRowIds) < 0) row.hide();
                row.attr("data-parent-id", parentId);
            }
            this.buildCols(item, row, childLevel);
            this.$body.append(row);
            if (item.hasOwnProperty(this.childRowProperty) && item[this.childRowProperty] && item[this.childRowProperty].length) {
                var expander = $('<i class="' + ($.inArray(id, this.expandedRowIds) >= 0 ? "glyphicon-chevron-down" : "glyphicon-chevron-right") + ' glyphicon-active"></i>').on("click", function() {
                    that.toggleChildren($(this), id);
                });
                row.find("td:first").prepend(expander);
                for (var i in item[this.childRowProperty]) {
                    this.buildRow(item[this.childRowProperty][i], childLevel + 1, id);
                }
            }
        },
        buildCols: function(item, row, childLevel) {
            for (var i in this.dataModel) {
                var model = this.dataModel[i];
                var col = $("<td></td>");
                var val = item[model.index];
                if (typeof model.formatter !== "undefined") val = model.formatter(val, item);
                col.append(val);
                row.append(col);
            }
            row.find("td").first().css("padding-left", 16 * childLevel + this.padLeft);
        },
        buildHeader: function() {
            var headerRow = this.$header.find("tr:first");
            headerRow.empty();
            var that = this;
            for (var i in this.dataModel) {
                var hCol = $("<td></td>").html(this.dataModel[i].name);
                if (!this.dataModel[i].hasOwnProperty("sortable") || this.dataModel[i].sortable) {
                    hCol.addClass("sortable").append($('<i class="glyphicon"></i>')).attr("data-sort-index", this.dataModel[i].index).hover(function() {
                        var me = $(this);
                        if (that.sortColumn == me.attr("data-sort-index")) return;
                        me.find("i").addClass("glyphicon-collapse-down");
                    }, function() {
                        var me = $(this);
                        if (that.sortColumn == me.attr("data-sort-index")) return;
                        me.find("i").removeClass("glyphicon-collapse-down");
                    }).click(function() {
                        var me = $(this);
                        me.find("i").removeClass(function(i, css) {
                            return (css.match(/\bglyphicon-\S+/g) || []).join(" ");
                        });
                        if (that.sortColumn == me.attr("data-sort-index")) {
                            that.sortDirection = that.sortDirection == "ASC" ? "DESC" : "ASC";
                            me.find("i").addClass(that.sortDirection == "ASC" ? "glyphicon-collapse-down" : "glyphicon-collapse-up");
                        } else {
                            me.closest("tr").find("i").removeClass(function(i, css) {
                                return (css.match(/\bglyphicon-\S+/g) || []).join(" ");
                            });
                            that.sortColumn = me.attr("data-sort-index");
                            that.sortDirection = "ASC";
                            me.find("i").addClass("glyphicon-collapse-down");
                        }
                        that.pager.refresh();
                    });
                }
                headerRow.append(hCol);
            }
        },
        buildFooter: function() {
            this.$footerRow.append(this.pager.$container);
        },
        mouseEnter: function(e) {
            this.mousedover = true;
            $(e.currentTarget).addClass("active");
        },
        mouseLeave: function(e) {
            this.mousedover = false;
            $(e.currentTarget).removeClass("active");
        },
        toggleChildren: function(obj, parentId) {
            var isCurrentlyExpanded = obj.hasClass("glyphicon-chevron-down");
            if (!isCurrentlyExpanded) {
                obj.removeClass("glyphicon-chevron-right").addClass("glyphicon-chevron-down");
                this.showChildRows(parentId);
                this.expandedRowIds.push(parentId);
            } else {
                obj.removeClass("glyphicon-chevron-down").addClass("glyphicon-chevron-right");
                this.hideChildRows(parentId);
                this.expandedRowIds.pop(parentId);
            }
        },
        showChildRows: function(parentId) {
            var childRows = this.$body.find("tr[data-parent-id=" + parentId + "]");
            childRows.each(function(index, el) {
                $(el).show();
            });
        },
        hideChildRows: function(parentId) {
            var childRows = this.$body.find("tr[data-parent-id=" + parentId + "]");
            childRows.each(function(index, el) {
                $(el).hide();
            });
        }
    };
    $.fn.pgGrid = function(option, override_existing) {
        return this.each(function() {
            var $this = $(this);
            var data = $this.data("pggrid");
            var options = typeof option == "object" && option;

            override_existing = override_existing || false;
            if (!data || override_existing == true){
                $this.data("pggrid", data = new PGGrid(this, options));
            }

            if (typeof option == "string") data[option]();
        });
    };
    $.fn.pgGrid.defaults = {
        childRowProperty: "children",
        dataModel: [ {
            name: "Id",
            index: "id"
        }, {
            name: "Value",
            index: "value"
        } ],
        dataTotalIndex: "total",
        dataItemIndex: "items",
        gridClass: "table table-condensed table-bordered table-striped",
        initLoader: '<div><i class="glyphicon glyphicon-refresh icon-spin"></i> Loading data...</div>',
        initialPage: 1,
        item: "<tr></tr>",
        itemIdProperty: "id",
        padLeft: 2,
        pageSize: 10,
        sortColumn: null,
        sortDirection: "ASC",
        title: "<h4>Data</h4>",
        url: null
    };
    $.fn.pgGrid.Constructor = PGGrid;
    var Pager = function() {
        "use strict";
        function Pager(options) {
            var that = this;
            this.options = $.extend({}, {}, options);
            this.reset();
            this.pageSize = Utils.getOption(this.options, "pageSize", 10);
            this.pageSizes = Utils.getOption(this.options, "pageSizes", [ {
                text: "10",
                value: 10
            }, {
                text: "20",
                value: 20
            }, {
                text: "30",
                value: 30
            }, {
                text: "All",
                value: -1
            } ]);
            this.showPageSizeSelector = Utils.getOption(this.options, "showPageSizeSelector", true);
            this.sortColumn = Utils.getOption(this.options, "sortColumn", null);
            this.sortDirection = Utils.getOption(this.options, "sortDirection", "ASC");
            this.render = this.options.render || this.render;
            this.setFooter = this.options.setFooter || this.setFooter;
            this.$container = $(this.options.container || '<div class="pull-left pager_container"></div>');
            this.$refreshBtn = $(this.options.refreshBtn || '<i class="glyphicon glyphicon-refresh icon-active"></i>').on("click", function() {
                that.refresh();
            });
            this.$loader = $(this.options.loader || '<i class="glyphicon glyphicon-refresh icon-spin"></i>');
            this.$startBtn = $(this.options.startBtn || '<i class="glyphicon glyphicon-fast-backward icon-disabled"></i>');
            this.$backBtn = $(this.options.backBtn || '<i class="glyphicon glyphicon-backward icon-disabled"></i>');
            this.$nextBtn = $(this.options.nextBtn || '<i class="glyphicon glyphicon-forward icon-disabled"></i>');
            this.$endBtn = $(this.options.endBtn || '<i class="glyphicon glyphicon-fast-forward icon-disabled"></i>');
            this.$pageCountText = $(this.options.pageCountText || "<span>1</span>");
            this.$pageSelector = $(this.options.pageSelector || '<select class="page-size-selector"></select>').on("change", function() {
                that.changePage(that.$pageSelector.val());
            });
            this.$pageSizeSelector = $(this.options.pageSizeSelector || '<select class="page-size-selector"></select>').on("change", function() {
                that.changePageSize(that.$pageSizeSelector.val());
            });
            this.render();
        }
        $.extend(Pager.prototype, {
            render: function() {
                this.$startBtn.appendTo(this.$container);
                this.$backBtn.appendTo(this.$container);
                $('<span class="page-size-selector-container">Page&nbsp;</span>').append(this.$pageSelector).append("&nbsp;of&nbsp;").append(this.$pageCountText).appendTo(this.$container);
                this.$nextBtn.appendTo(this.$container);
                this.$endBtn.appendTo(this.$container);
                this.$refreshBtn.appendTo(this.$container);
                this.$loader.appendTo(this.$container);
                if (this.showPageSizeSelector) {
                    for (var i in this.pageSizes) {
                        var pageSize = this.pageSizes[i];
                        this.$pageSizeSelector.append($("<option></option>").attr("value", pageSize.value).text(pageSize.text));
                    }
                    $('<span class="page-size-selector-container"></span>').append("<span>Page&nbsp;Size:&nbsp;</span>").append(this.$pageSizeSelector).appendTo(this.$container);
                }
            },
            setFooter: function(totalRecords) {
                var totalPages = this.pageSize == -1 ? 1 : Math.ceil(totalRecords / this.pageSize);
                this.$pageSelector.text(this.currentPage);
                this.$pageCountText.text(totalPages);
                this.disableButtons();
                var that = this;
                if (this.currentPage > 1) {
                    this.enableButton(this.$startBtn, function() {
                        that.getPage(1);
                    });
                    this.enableButton(this.$backBtn, function() {
                        that.prevPage();
                    });
                }
                if (this.currentPage < totalPages) {
                    this.enableButton(this.$endBtn, function() {
                        that.getPage(totalPages);
                    });
                    this.enableButton(this.$nextBtn, function() {
                        that.nextPage();
                    });
                }
                for (var i = 1; i <= totalPages; i++) {
                    var option = $("<option></option>").attr("value", i).text(i);
                    if (i == this.currentPage) option.attr("selected", "selected");
                    this.$pageSelector.append(option);
                }
            },
            nextPage: function() {
                this.getPage(this.currentPage + 1);
            },
            prevPage: function() {
                this.getPage(this.currentPage - 1);
            },
            reset: function() {
                this.currentPage = this.options.intialPage || 1;
            },
            refresh: function() {
                var that = this;
                this.showLoader();
                this.disableButtons();
                this.$pageSelector.attr("disabled", "disabled");
                this.$pageSizeSelector.attr("disabled", "disabled");
                $(this).trigger("onRefresh", {
                    currentPage: this.currentPage,
                    pageSize: this.pageSize,
                    onComplete: function(totalRecords) {
                        that.$pageSelector.removeAttr("disabled");
                        that.$pageSizeSelector.removeAttr("disabled");
                        that.setFooter(totalRecords);
                        that.hideLoader();
                    }
                });
            },
            getPage: function(page) {
                if (!page) page = this.currentPage;
                this.currentPage = page;
                this.refresh();
            },
            changePage: function(page) {
                this.currentPage = page;
                this.refresh();
            },
            changePageSize: function(pageSize) {
                this.pageSize = pageSize;
                this.currentPage = 1;
                this.refresh();
            },
            showLoader: function() {
                this.$refreshBtn.hide();
                this.$loader.show();
            },
            hideLoader: function() {
                this.$refreshBtn.show();
                this.$loader.hide();
            },
            disableButtons: function() {
                this.disableButton(this.$startBtn);
                this.disableButton(this.$backBtn);
                this.disableButton(this.$nextBtn);
                this.disableButton(this.$endBtn);
            },
            disableButton: function(btn) {
                btn.off();
                btn.removeClass("icon-active").addClass("icon-disabled");
            },
            enableButton: function(btn, fn) {
                btn.removeClass("icon-disabled").addClass("icon-active").on("click", fn);
            }
        });
        return Pager;
    }();
    var Utils = {
        isNullOrWhitespace: function(input) {
            if (this.isUndefined(input) || input == null) return true;
            if (this.isObject) return false;
            if (this.isString(input)) return this.isEmptyString(input);
            return false;
        },
        isString: function(obj) {
            return typeof obj === "string";
        },
        isNumber: function(obj) {
            return typeof obj === "number";
        },
        isArray: $.isArray,
        isFunction: $.isFunction,
        isObject: $.isPlainObject,
        isUndefined: function(obj) {
            return typeof obj === "undefined";
        },
        isEmptyString: function(str) {
            return !str || /^\s*$/.test(str);
        },
        getOption: function(option, property, def) {
            if (!this.isObject(option) || !option.hasOwnProperty(property)) return def;
            return option[property];
        }
    };
})(window.jQuery);