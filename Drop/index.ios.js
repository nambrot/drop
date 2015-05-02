/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';

var React = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  NavigatorIOS,
  TouchableOpacity,
  ScrollView,
} = React;

/*
var event
name: (location)
type: (enum of something)
starttime: date
length: int




*/

var Svg = require('react-native-svg'); 
var Path = Svg.Path

var Drop = React.createClass({
  render: function() {
    return (
    <NavigatorIOS
      style={{flex:1}}
      initialRoute={{
        component: MainScreen,
        title: 'Drop',
      }} />
    );
  }
});

var MainScreen = React.createClass({
  getInitialState() {
    return {timespan: 'Today',
      colors: ["#A10840", '#F03316', '#A19E08', '#E0C33F', '#1D8A7F'],
      pieData: [52,15,20,80,40],
      legend: ["Home", "Work", "Bars", "Gym", "In transit"],
    }
  },

  returnPaths() {
    var paths = [];
    var total = this.state.pieData.reduce(function (accu, that) { return that + accu; }, 0);
    var sectorAngleArr = this.state.pieData.map(function (v) { return 360 * v / total; });

    var startAngle = 0;
    var endAngle = 0;
    for (var i=0; i<sectorAngleArr.length; i++){
        startAngle = endAngle;
        endAngle = startAngle + sectorAngleArr[i];

        var x1,x2,y1,y2 ;

        x1 = parseInt(Math.round(200 + 195*Math.cos(Math.PI*startAngle/180)));
        y1 = parseInt(Math.round(200 + 195*Math.sin(Math.PI*startAngle/180)));

        x2 = parseInt(Math.round(200 + 195*Math.cos(Math.PI*endAngle/180)));
        y2 = parseInt(Math.round(200 + 195*Math.sin(Math.PI*endAngle/180)));

        var d = "M200,200  L" + x1 + "," + y1 + "  A195,195 0 " + 
                ((endAngle-startAngle > 180) ? 1 : 0) + ",1 " + x2 + "," + y2 + " z";
        //alert(d); // enable to see coords as they are displayed
        var c = parseInt(i / sectorAngleArr.length * 360);
        var f = "hsl(" + c + ", 66%, 50%)"
        paths.push(<Path d={d} fill={this.state.colors[i]} stroke={this.state.colors[i]} strokeWidth="3" strokeMiterlimit="10" />);
    }
    return paths;
  },

  legend() {
    var l = [];
    for (var i=0; i<this.state.legend.length; i++) {
      var x = function (title) {
        l.push(<TouchableOpacity onPress={() => {
            this.props.navigator.push({
                title: title,
                component: TopicDetailPage
            })
        }}>
          <View style={styles.legendView}>
          <View style={[styles.legendColor, {backgroundColor: this.state.colors[i]}]}></View>
          <Text style={styles.legendName}>{this.state.legend[i]}</Text>
          </View>
          </TouchableOpacity>
          )
      }.bind(this) (this.state.legend[i])
    }
    return l;
  },

  render: function() { 
    return(
      <View style={styles.container}>
        <Text style={styles.title}>{this.state.timespan}</Text>
        <View style={styles.chart}>
          <Svg width={400} height={400} style={{width: 250, height: 250}}>
            {this.returnPaths()}
          </Svg>
        </View>
        <ScrollView contentInset={{top: -64}} style={styles.legend}>
          <View style={styles.topBorder}></View>
          {this.legend()}
        </ScrollView>
      </View>
    )
  }
})

var TopicDetailPage = React.createClass({
  render() {
    return(
      <View>
      <Text>Hi</Text>
      </View>
    )
  }
})

var styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingTop: 64,
    backgroundColor: '#F5FCFF',
  },
  title: {
    fontSize: 20,
    textAlign: 'center',
    color: 'black',
    margin: 10,
  },
  chart: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  legend: {
    marginTop: 10,
  },
  legendView: {
    height: 50,
    flexDirection: 'row',
    alignItems: 'center',
    borderBottomWidth: 1,
    borderColor: 'black'
  },
  legendColor: {
    height: 40,
    width: 40,
    margin: 10
  },
  legendName: {
    margin: 10
  },
  topBorder: {
    height: 1,
    backgroundColor: 'black'
  }
});

AppRegistry.registerComponent('Drop', () => Drop);
