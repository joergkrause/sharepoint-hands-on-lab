(function(module,$) {
    "use strict";

    pd.FilterLibraryApp = function() {
        var
           viewModel = new pd.FilterLibraryViewModel(),
           debug = true,
           wpCtx = null,
           wpEvent = null,
           _module = {
               start: start
           };
        return _module;

        function locateListView() {
            EnsureScript("inplview", typeof InitAllClvps, null, true);
            InitAllClvps();

            for(var k in g_ctxDict) {
                if (debug && window.console) console.log(g_ctxDict[k]);
                if (g_ctxDict[k].ListTitle === 'Documents') {
                    wpCtx = window['ctx'+g_ctxDict[k].ctxId];
                    break;
                }
            }
            if (debug && window.console) {
                console.log(wpCtx.clvp);
                console.log(wpCtx.clvp.ctx);
                console.log(wpCtx.clvp.ctx.view);
                console.log(wpCtx.clvp.ctx.ListSchema.Filter);
                console.log(wpCtx.clvp.ctx.ListData.FilterLink);
            }
            var clvp = (wpCtx && wpCtx.clvp) ? wpCtx.clvp : null;
            wpEvent = { clvp: clvp, event: { currentCtx: { clvp: clvp } } };
            viewModel.LibraryTitle(wpCtx.ListTitle);
            viewModel.LibrarySubTitle('All');
            viewModel.Working(false);
            //$('#' + wpCtx.wpq + '_ListTitleViewSelectorMenu_Container').hide();
        }

        function filterByText() {
            if (!wpCtx) {
                alert('Unable to filter: the list view webpart could not be located!');
                return;
            }
            var filterText = this.FilterText();
            if (debug && window.console) { console.log(">>FilterByTextText+"]"); }

            var $webpart = $("#WebPart" + wpCtx.wpq);
                $webpart.find("tr.ms-itmhover").each(function
                   var $tr = $(this);
                    if (filterText && filterText.length) {
                        var
                           r = new RegExp(filterText,'gi'), 
                           matched = false,
                           $tds = $tr.find(".ms-vb-title,.ms-vb-2").first
                        $tr.find(".ms-vb-title,.ms-vb2").each(function
                           var td = $(this).text();
                            if(!r.test(td)) return true;
                            matched = true;
                            return false;
                        });
                        if(matched) $tr.fadeIn(250);
                        else $tr.fadeOut(250);
                    } else {
                        $tr.fadeIn(250);
                    }
                });
            }

            function onFilterChange(filterType) {
                if (!wpCtx) {
                    alert('Unable to filter: the list view webpart could not be located!');
                    return;
                }

                var
                   filterColumns = [],
                   filterValues = [],
                   fyv = this.SelectedYear(),
                   fym = this.SelectedMonth();

                if (fyv && fyv.length) {
                    filterColumns.push('catYear
                    filterValues.push(fyv);
                }
                if (fym && fym.length) {
                    filterColumns.push('catMonth
                    filterValues.push(fym);
                }

                var filterUrl;
                if (!filterColumns.length) {
                    /* clear filter */
                    filterUrl = _spPageContextInfo.webAbsoluteUrl + window.location.pathname + '?View=' + wpCtx.clvp.ctx.view + '&FilterClear=1';
                } else {
                    filterUrl = _spPageContextInfo.webAbsoluteUrl + window.location.pathname + '?View=' + wpCtx.clvp.ctx.view;
                    for(var i = 0; i < filterColumns.length; i++) {
                        if (debug && window.console) { console.log(">>FilterByColumns[i]+"] = ["+filterValues[i]+"]"); }
                        filterUrl += '&FilterField' 
                                       + (i+1) + '=' + filterColumns[i]
                                     + '&FilterValue' 
                                       + (i+1) + '=' + filterValues[i];
                        }
                        if (debug && window.console) { console.log(">>FilterUrlrl); }
                        }

                        if (wpEvent.clvp == null || wpEvent.clvp.ctx == null || !wpEvent.clvp.ctx.IsClientRendering) {
                            HandleFilter(wpEvent.event, filterUrl);
                        } else {
                            wpEvent.clvp.RefreshPaging(filterUrl);
                            wpEvent.clvp.ctx.queryString = filterUrl;
                        }
                    }

                    function start() {
                        ko.applyBindings(viewModel, $('#cdtm').get(0));
                        viewModel.FilterText.subscribe(filterByText, viewModel, "change");
                        viewModel.SelectedYear.subscribe(onFilterChange.bind(viewModel, 'year'));
                        viewModel.SelectedMonth.subscribe(onFilterChange.bind(viewModel, 'month'));
                        locateListView();
                    }
                }();

                $(pd.FilterLibraryApp.start);

            })({ Name: 'Module' },jQuery);
