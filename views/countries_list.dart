import 'package:covid_tracker/Services/states_services.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CountriesList extends StatefulWidget {
  const CountriesList({Key? key}) : super(key: key);

  @override
  State<CountriesList> createState() => _CountriesListState();
}

class _CountriesListState extends State<CountriesList> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    StatesServices statesServices=StatesServices();
    return SafeArea(
      child: Scaffold(

        appBar: AppBar(
          elevation: 0,

        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: searchController,
                  onChanged: (value){
                    setState(() {
                      
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search with Country Name",
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future:statesServices.fetchCountriesApi(),
                  builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {

                    if(!snapshot.hasData){
                        return ListView.builder(
                            itemCount: 8,
                            itemBuilder: (context, index)
                            {
                              return Shimmer.fromColors(
                                 baseColor: Colors.grey.shade700,
                                highlightColor: Colors.grey.shade100,
                                 child:Column(
                                   children: [
                                     ListTile(
                                       title:Container(height:12 ,width:double.infinity,color: Colors.white,),
                                       subtitle:Container(height:12 ,width:double.infinity,color: Colors.white,),
                                       leading: Container(height:50 ,width:50,color: Colors.white,),

                                     ),
                                   ],
                                 ),
                              );

                            }
                        );
                    }else{
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                          itemBuilder: (context, index)
                      {
                        String name= snapshot.data![index]['country'];
                        if(searchController.text.isEmpty){
                          return Column(
                            children: [
                              ListTile(
                                title:Text(snapshot.data![index]['country']),
                                subtitle:Text(snapshot.data![index]['countryInfo']['iso3']),
                                leading: Image(
                                  height:50,
                                  width: 50,
                                  image: NetworkImage(snapshot.data![index]['countryInfo']['flag']),
                                ),
                              ),
                            ],
                          );
                        }
                        else if(name.toLowerCase().contains(searchController.text.toLowerCase())){
                          return Column(
                            children: [
                              ListTile(
                                title:Text(snapshot.data![index]['country']),
                                subtitle:Text(snapshot.data![index]['countryInfo']['iso3']),
                                leading: Image(
                                  height:50,
                                  width: 50,
                                  image: NetworkImage(snapshot.data![index]['countryInfo']['flag']),
                                ),
                              ),
                            ],
                          );
                        }
                        else{
                          return Container();
                        }
                      }
                      );
                    }

                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
