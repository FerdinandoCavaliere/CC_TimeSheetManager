<%@ Page Title="" Language="C#" MasterPageFile="~/TimeSheetMasterPage.Master" AutoEventWireup="true" 
    CodeBehind="DashBoard.aspx.cs" Inherits="TimeSheetManager.DashBoard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Styles/StiliDashBoard.css" rel="stylesheet" type="text/css" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="divAnni" class="ElencoAnni">
        <asp:Panel ID="PnlAnniTaskValidi" runat="server">

        </asp:Panel>
    </div>
    <div id="divDashBoard" class="DivDashBoard">
        <asp:Panel ID="PnlRisorse" runat="server" CssClass="PnlRisorse">
            Risorse
            <asp:DropDownList 
                ID="DdlRisorse" 
                runat="server" 
                DataValueField="Codice"
                DataTextField="Nominativo" 
                ClientIDMode="Static" 
                CssClass="Testo DdlRisorse" 
                AutoPostBack="true"
                OnSelectedIndexChanged="DdlRisorse_SelectedIndexChanged"></asp:DropDownList>
        </asp:Panel>
           
        <div class="DivSingleChart">
            <canvas id="chartOrePerMese"></canvas>
        </div>

        <div class="DivSingleChart">
            <canvas id="chartOrePerMesePerFiguraProfessionale"></canvas>
        </div>

        <div class="DivSingleChart">
            <canvas id="chartTasksPerMese"></canvas>
        </div>

        <div class="DivSingleChart">
            <canvas id="chartTasksPerMesePerFiguraProfessionale"></canvas>
        </div>

        <div class="DivSingleChart">
            <canvas id="chartTasksPerProgetto"></canvas>
        </div>
    </div>

    <script type="text/javascript">
        function CreaDashBoardOrePerMese() {

            var ctx = document.getElementById('chartOrePerMese').getContext('2d');
            var myChart = new Chart(ctx, {
                type: 'bar',
                data: <%= orePerMese %>,
                options: {
                    title: {
                        display: true,
                        text: 'ORE PER MESE'
                    },
                    scales: {
                        xAxes: [{
                            gridLines: {
                                display: false
                            }
                        }],
                        yAxes: [{
                            ticks: {
                                min: 0
                            },
                            gridLines: {
                                display: false
                            }
                        }]
                    },
                    legend: {
                        display: false
                    }
                }
            });
        }

        function CreaDashBoardOrePerMesePerFiguraProfessionale() {
            var ctx = document.getElementById('chartOrePerMesePerFiguraProfessionale').getContext('2d');
            var myChart = new Chart(ctx, {
                type: 'line',
                data: <%= orePerMesePerFiguraProfessionale %>,
                options: {
                    title: {
                        display: true,
                        text: 'ORE PER MESE PER FIGURA PROFESSIONALE'
                    },
                    scales: {
                        xAxes: [{
                            gridLines: {
                                display: false
                            }
                        }],
                        yAxes: [{
                            ticks: {
                                min: 0
                            },
                            gridLines: {
                                display: false
                            }
                        }]
                    },
                    legend: {
                        display: true
                    }
                }
            });
        }

        function CreaDashBoardTasksPerMese() {
            var ctx = document.getElementById('chartTasksPerMese').getContext('2d');
            var myChart = new Chart(ctx, {
                type: 'bar',
                data: <%= tasksPerMese %>,
                options: {
                    title: {
                        display: true,
                        text: 'TASKS PER MESE'
                    },
                    scales: {
                        xAxes: [{
                            gridLines: {
                                display: false
                            }
                        }],
                        yAxes: [{
                            ticks: {
                                min: 0,
                                stepSize: 10
                            },
                            gridLines: {
                                display: false
                            }
                        }]
                    },
                    legend: {
                        display: false
                    }
                }
            });
        }

        function CreaDashBoardTasksPerMesePerFiguraProfessionale() {
            var ctx = document.getElementById('chartTasksPerMesePerFiguraProfessionale').getContext('2d');
            var myChart = new Chart(ctx, {
                type: 'line',
                data: <%= tasksPerMesePerFiguraProfessionale %>,
                options: {
                    title: {
                        display: true,
                        text: 'TASKS PER MESE PER FIGURA PROFESSIONALE'
                    },
                    scales: {
                        xAxes: [{
                            gridLines: {
                                display: false
                            }
                        }],
                        yAxes: [{
                            ticks: {
                                min: 0,
                                stepSize: 10
                            },
                            gridLines: {
                                display: false
                            }
                        }]
                    },
                    legend: {
                        display: true
                    }
                }
            });
        }

        function CreaDashBoardTasksPerProgetto() {
            var ctx = document.getElementById('chartTasksPerProgetto').getContext('2d');
            var myChart = new Chart(ctx, {
                type: 'bar',
                data: <%= tasksPerProgetto %>,
                options: {
                    title: {
                        display: true,
                        text: 'TASKS PER PROGETTO'
                    },
                    scales: {
                        xAxes: [{
                            gridLines: {
                                display: false
                            }
                        }],
                        yAxes: [{
                            ticks: {
                                min: 0,
                                stepSize: 20
                            },
                            gridLines: {
                                display: false
                            }
                        }]
                    },
                    legend: {
                        display: false
                    }
                }
            });
        }

        CreaDashBoardOrePerMese();
        CreaDashBoardOrePerMesePerFiguraProfessionale();
        CreaDashBoardTasksPerMese();
        CreaDashBoardTasksPerMesePerFiguraProfessionale();
        CreaDashBoardTasksPerProgetto();
    </script>
</asp:Content>
