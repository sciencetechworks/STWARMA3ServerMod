#define STW_MIN_VALUE -10000000

/** 
 Return the average of a list of numbers
**/
stwf_average=
{
 params ["_samples"];
 _n=count _samples;
 _sum=0;
 {
  _sample=_x;
  _sum=_sum+_sample; 
 } forEach _samples;
 _average=_sum/_n;
 _average;
};

/**
 Return the standardDeviation of a list of numbers
//[samples,mean]
**/
stwf_standardDeviation=
{
 params ["_samples","_mean"];
 _n=count _samples;

 _sum=0;
 {
   _value=_x-_mean;
   _value=_value*_value;
   _sum=_sum+_value;
 } forEach _samples;
 
 _sum=_sum/(_n-1);
 
 _s=sqrt _sum;
 _s;
};

/**
 Return the index of the maximum value of a collection of numbers
**/
stwf_maxValueIndex={
 _values=_this;
 _max= STW_MIN_VALUE;
 _index=0;
 _indexOfMax=0;
 {
  _value=_x;
  if (!isNil "_value") then
  {  
	  if (_value>_max) then
	  {
	   _indexOfMax=_index;
	   _max=_value;
	  };
  };
  _index=_index+1;
 } forEach _values;
 _indexOfMax;
};

/**
 Return the list of numbers without duplicates
**/
stw_NoDuplicates={
 params ["_listOfNumbers"];
 _noduplicates=[];
 {
   if (!(_x in _noduplicates) ) then
   {
    _noduplicates pushBack _x;
   }
 } forEach _listOfNumbers;
 
 _noduplicates;
};

/**
 Check if a number is Even
**/
stwf_isEven={
 params["_number"];
 _result=false;
 if (_number%2==0) then {_result=true;};
 _result
};

/**
 Check if a number is Odd
**/
stwf_isOdd={
 params["_number"];
 _result=false;
 if (_number%2!=0) then {_result=true;};
 _result
};

/**
Get the median of a sample
**/
stwf_median=
{
 params ["_samples"];
 _orderedSamples=+_samples;
 _orderedSamples sort  true;
 _n= count _orderedSamples;
 _index=_n/2;
 _result=0;
 if (_n%2==0) then
 {
  _result=_orderedSamples select _index;
 } else
 {
  _mn=_n/2.0;
  _lowerIndex=floor _mn;
  _higherIndex=ceil _mn;
  _v1=_orderedSamples select _lowerIndex;
  _v2=_orderedSamples select _higherIndex;
  _result=(_v1+_v2)/2.0;
 };
 _result
};

/**
 Calculate Quartiles
 Returns [medianQlow,medianQ,medianQhigh]
 value<medianQlow--> quartile1 (0..25%)
 value>medianQlow && value<medianQ --> quartile2 (25%..50%)
 value>=medianQ && value<medianQhigh --> quartile3 (50%..75%)
 value>=medianQhigh --> quartile4 (75%..100%)
 https://en.wikipedia.org/wiki/Quartile
**/
stwf_quartiles={
 params["_samples"];
 _orderedSamples=+_samples;
 _medianQ=[_orderedSamples] call stwf_median;
 _halfOne=[];
 _halfTwo=[];
 _n=count _orderedSamples;
 _isOdd=(_n%2)==0;
 {
   _value=_x;
   
   if (_value!=_medianQ) then
   {
	   if (_value<_medianQ) then
	   { 
		_halfOne pushBack _value;
	   } else
	   {
		_halfTwo pushBack _value;
	   };
   } else
   {
    if (_isOdd) then
	{
		_halfOne pushBack _value;
		_halfTwo pushBack _value;
	} else
	{
		_halfTwo pushBack _value;
	};
   };
 } forEach _orderedSamples;
 _medianQlow=[_halfOne] call stwf_median; 
 _medianQhigh=[_halfTwo] call stwf_median;
 _result=[_medianQlow,_medianQ,_medianQhigh];
 _result
};

/**
 Interquartile range
**/
stwf_IQR=
{
 params ["_quartiles"];
 _mQlow=_quartiles select 0;
 //_mQ=_quartiles select 1;
 _mQhigh=_quartiles select 2;
 _result=_mQHigh-_mQlow;
 _result
};

/**
 IsOutlier
**/
stwf_isOutlier=
{
 params ["_value","_quartiles","_iqr"];
 _v=(1.5*_iqr);
 _low=(_quartiles select 0)-_v ;
 _high=(_quartiles select 2)+_v ;
 _result=false;
 if ((_value<_low)||(_value>_high)) then
 {
	_result=true;
 };
 _result
};

/**
Determine the values quartile
returns 1,2,3,4
**/
stwf_whatIsMyQuartile=
{
 params ["_value","_quartiles"];
 /*
 value<medianQlow--> quartile1 (0..25%)
 value>medianQlow && value<medianQ --> quartile2 (25%..50%)
 value>=medianQ && value<medianQhigh --> quartile3 (50%..75%)
 value>=medianQhigh --> quartile4 (75%..100%)
 */
 _mQlow=_quartiles select 0;
 _mQ=_quartiles select 1;
 _mQhigh=_quartiles select 2;
 _result=0;
 if (_value<_mQlow) then  {_result=1};
 if ((_value>=_mQlow)&&(_value<_mQ)) then {_result=2};
 if ((_value>=_mQ)&&(_value<_mQHigh)) then {_result=3};
 if (_value>_mQhigh) then  {_result=4};
 _result
};

/**
 get a VERY_SMALL,SMALL,NORMAL,BIG,VERY_BIG classification  
 depending on the average and the stdev
**/
stwf_getStatisticalAverageBasedClassification=
{
 params ["_value","_average","_stddev"];
 _sigma=_stddev;
 _twosigma=2*_stddev;
 _classification="NORMAL";
 if (_value<=_average-_twosigma) exitWith {_classification="VERY_SMALL";_classification};
 if (_value<=_average-_sigma) exitWith {_classification="SMALL";_classification};
 if (_value>=_average+_sigma) exitWith {_classification="BIG";_classification};
 if (_value>=_average+_twosigma) exitWith {_classification="VERY_BIG";_classification};
 _classification
};

/**
 get a  SMALL,NORMAL,BIG classification  
 depending on the quartile
**/
stwf_getStatisticalQuartileBasedClassification=
{
 params ["_value","_quartiles"];
 _quartileValue=[_value,_quartiles] call stwf_whatIsMyQuartile;
 _classification="NORMAL";

 if (_quartileValue==1) exitWith {_classification="SMALL";_classification};
 if (_quartileValue==4) exitWith {_classification="BIG";_classification};
 _classification
};
