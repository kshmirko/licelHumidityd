module licelformat;
import std.datetime.date;
import std.array;
import std.uni : isWhite;
import std.conv;
import std.stdio;
import std.string;
import std.file;


enum EDatasetType {
	dtAnalog=0,
	dtPhoton,
	dtAnalogSquared,
	dtPhotonSquared 
}

enum EPolarizationStatus{
	psNone=0,
	psVertical,
	psHorizontal,
	psRightCircular,
	psLeftCircular		
}

enum EPolarizationScattStatus:char{
	psNone='o',
	psParallel='p',
	psCross='s',
	psRightCircular='r',
	psLeftCircular='l'		
}


class LicelProfile {
	
	@property bool isActive() {return m_isActive;}
	@property EDatasetType dsType(){return m_datsetType;}
	@property bool isPhoton() {return m_datsetType==EDatasetType.dtPhoton;}
	@property int nDataPoints(){return m_nDataPoints;}
	@property EPolarizationStatus laserPolstate(){return m_laserPolstate;}
	@property double wavelength(){return m_wavelength;}
	@property EPolarizationScattStatus scatPolStatus(){return m_scatPolStatus;}
	@property int nShots(){return m_nShots;}
	@property double discrLevel(){return m_discrLevel;}
	@property int deviceID(){return m_deviceID;}
	@property uint[] data(){return m_data;}
	@property uint[] data(uint[]value){return m_data=value;}
	this(string dataline){
		parseLine(dataline);
	}
	
private:
	
	// Разбирает строку с ткустом на лексемы
	void parseLine(string dataline){
		auto items=dataline.split();
		//writeln(items);
		m_isActive = cast(bool)(parse!int(items[0]));
		m_datsetType = cast(EDatasetType)(parse!int(items[1]));
		m_nlaser = parse!int(items[2]);
		m_nDataPoints = parse!int(items[3]);
		m_laserPolstate=cast(EPolarizationStatus)parse!int(items[4]);
		m_highVoltage=parse!double(items[5]);
		m_binWidth=parse!double(items[6]);
		auto tmp=items[7].split(".");
		m_wavelength=parse!double(tmp[0]);
		m_scatPolStatus=cast(EPolarizationScattStatus)(tmp[1][0]);
		m_binShift = parse!int(items[10]);
		m_decBinShift = parse!int(items[11]);
		m_adcBits = parse!int(items[12]);
		m_nShots=parse!int(items[13]);
		m_discrLevel = parse!double(items[14]);
		m_deviceID = cast(int)(items[15][2]-'0');
	}
	
private:
	bool m_isActive;
	EDatasetType m_datsetType;
	int m_nlaser;
	int m_nDataPoints;
	EPolarizationStatus m_laserPolstate;
	double m_highVoltage;
	double m_binWidth, m_wavelength;
	EPolarizationScattStatus m_scatPolStatus;
	int m_binShift, m_decBinShift;
	int m_adcBits;
	int m_nShots;
	double m_discrLevel;
	int m_deviceID;
	uint [] m_data;
	
}

class LicelFile{
	
	@property LicelProfile[] Profiles(){return m_Profiles;} 
	
	this(string fname){
		LoadFile(fname);
	}
	
private:
	void LoadFile(string fname){
		if (exists(fname)){
			File fin = File(fname, "rb");
			scope(exit) fin.close();
			m_fname = strip(fin.readln());
			
			auto tmp = strip(fin.readln()).split();
			m_measurementSite = tmp[0];
			auto tmp1 = tmp[1].split('/');
			auto tmp2 = tmp[2].split(':');
			m_measurementStartTime = DateTime(parse!int(tmp1[2]), parse!int(tmp1[1]), parse!int(tmp1[0]),
				parse!int(tmp2[0]),parse!int(tmp2[1]),parse!int(tmp2[2]));
			
			tmp1 = tmp[3].split('/');
			tmp2 = tmp[4].split(':');
			m_measurementStopTime = DateTime(parse!int(tmp1[2]), parse!int(tmp1[1]), parse!int(tmp1[0]),
				parse!int(tmp2[0]),parse!int(tmp2[1]),parse!int(tmp2[2]));
			
			m_altitudeAboveSeaLevel = parse!double(tmp[5]);
			m_longitude = parse!double(tmp[6]);
			m_latitude = parse!double(tmp[7]);
			m_zenith=parse!double(tmp[8]);
			
			tmp = strip(fin.readln()).split();
			m_nLaser1Shots = parse!int(tmp[0]);
			m_laser1Freq = parse!int(tmp[1]);
			m_nLaser2Shots = parse!int(tmp[2]);
			m_laser2Freq = parse!int(tmp[3]);
			m_nDatasets = parse!int(tmp[4]);
			m_nLaser3Shots = parse!int(tmp[5]);
			m_laser3Freq = parse!int(tmp[6]);
			
			m_Profiles.length = m_nDatasets;
			for(int i=0; i<m_nDatasets; i++){
				auto tmp_0=strip(fin.readln());
				m_Profiles[i] = new LicelProfile(tmp_0);
			}
			fin.readln();
			auto crlf = new byte[2];
			for(int i=0; i<m_nDatasets; i++){
				auto profile = fin.rawRead(new uint[m_Profiles[i].nDataPoints]);
				fin.rawRead(crlf);
				m_Profiles[i].data = profile;
			}
			
			
		}
		
	}
	
	
	string m_fname;
	string m_measurementSite;
	DateTime m_measurementStartTime, m_measurementStopTime;
	double m_altitudeAboveSeaLevel, m_longitude, m_latitude, 
		m_zenith, m_azimuth;
	int m_nLaser1Shots, m_laser1Freq, m_nLaser2Shots, m_laser2Freq, m_nDatasets,
		m_nLaser3Shots, m_laser3Freq;
		
	LicelProfile[] m_Profiles;
}


alias LicelPack = LicelFile[string];

LicelPack LoadPackage(string[] files){
	LicelPack ret;
	
	foreach(fname; files){
		ret[fname] = new LicelFile(fname);
	}
	
	return ret;
}