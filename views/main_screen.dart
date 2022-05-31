import 'package:covid_tracker/Model/WorldStatesModel.dart';
import 'package:covid_tracker/Services/states_services.dart';
import 'package:covid_tracker/View/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStatistics extends StatefulWidget {
  const WorldStatistics({Key? key}) : super(key: key);

  @override
  State<WorldStatistics> createState() => _WorldStatisticsState();
}

class _WorldStatisticsState extends State<WorldStatistics> with TickerProviderStateMixin{
  late final AnimationController _controller =
  AnimationController(duration: const Duration(seconds: 3), vsync: this)
    ..repeat();
final  colorList=<Color>[
  Colors.blue,
  Colors.green,
  Colors.red
];


  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    StatesServices statesServices=StatesServices();
    return Scaffold(

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [

              const SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: statesServices.fetchWorldStatesRecord(),
                  builder: (context,AsyncSnapshot<WorldStateModel> snapshot){
                if(!snapshot.hasData){
                return Center(
                  child: Expanded(
                      flex: 1,
                      child: SpinKitFadingCircle(
                        //color: Colors.white,
                        size: 50.0,
                        controller: _controller ,
                      )
                  ),
                );
                }
                else{
                      return Column(
                        children: [
                          PieChart(
                            dataMap:{
                              "Total":double.parse(snapshot.data!.cases!.toString()),
                              "Recovered":double.parse(snapshot.data!.recovered!.toString()),
                              "Death":double.parse(snapshot.data!.deaths!.toString()),
                            },
                            chartValuesOptions: const ChartValuesOptions(showChartValuesInPercentage: true),
                            legendOptions: const LegendOptions(
                                legendPosition: LegendPosition.left ,
                                legendTextStyle:  TextStyle(color: Colors.black)
                            ),
                            animationDuration: const Duration(milliseconds: 1200),
                            chartType: ChartType.ring,
                            chartRadius: MediaQuery.of(context).size.width/2.8,
                            colorList: colorList,

                          ),
                          SizedBox(height: 2),
                          Padding(
                            padding:  EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.05),
                            child: Card(
                              child: Column(
                                children: [
                                  ReusableRow(title: 'Total', value: snapshot.data!.cases!.toString()),
                                  ReusableRow(title: 'Deaths', value: snapshot.data!.deaths!.toString()),
                                  ReusableRow(title: 'Recovered', value: snapshot.data!.recovered!.toString()),
                                  ReusableRow(title: 'Active', value: snapshot.data!.active!.toString()),
                                  ReusableRow(title: 'Critical', value: snapshot.data!.critical!.toString()),
                                  ReusableRow(title: 'Today Cases', value: snapshot.data!.todayCases!.toString()),
                                  ReusableRow(title: 'Today Deaths', value: snapshot.data!.todayDeaths!.toString()),
                                  ReusableRow(title: 'Today Recovered', value: snapshot.data!.todayRecovered!.toString()),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const CountriesList()));
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: const Center(
                                child: Text("Track Statistics",style: TextStyle(fontSize: 20,),),
                              ),
                            ),
                          )
                        ],
                      );
                }
              }),


            ],
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title,value;
  ReusableRow({Key? key,required this.title,required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          const SizedBox(height: 5,),
          const Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
