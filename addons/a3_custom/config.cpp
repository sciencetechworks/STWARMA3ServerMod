

class CfgPatches {
	class A3_custom {
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {};
	};
};

class CfgFunctions {
	class A3C {
		class A3CCustom {
			file = "a3_custom\init";
			class init {
				postInit = 1;
			};
		};
	};
	
	class gdsn {
		#include "functions\rooftopStaticWeapons.hpp"
	};

		#define INTERNAL_FUNCTION(x)				\
		class x									\
		{										\
			description = "Internal Function";	\
		};

	#define EXPORTED_FUNCTION(x,y)				\
		class x									\
		{										\
			description = y;					\
		};

	class FHQ {
		class TaskTrackerInternal {
			tag="FHQ";
			file="a3_custom\functions\fhq_tasktracker";

			class ttiInit
			{
				description = "Internal function, called automatically";
				preInit = 1;
			};

			class ttiPostInit
			{
				description = "Internal function, called automatically";
				postInit = 1;
			};

			INTERNAL_FUNCTION(ttifilterUnits)
			INTERNAL_FUNCTION(ttiAddBriefingEntry)
			INTERNAL_FUNCTION(ttiHasBriefingEntry)
			INTERNAL_FUNCTION(ttiUpdateBriefingList)
			INTERNAL_FUNCTION(ttiGetTaskId)
			INTERNAL_FUNCTION(ttiGetTaskDesc)
			INTERNAL_FUNCTION(ttiGetTaskTitle)
			INTERNAL_FUNCTION(ttiGetTaskWp)
			INTERNAL_FUNCTION(ttiGetTaskTarget)
			INTERNAL_FUNCTION(ttiGetTaskState)
			INTERNAL_FUNCTION(ttiGetTaskName)
			INTERNAL_FUNCTION(ttiGetTaskType)
			INTERNAL_FUNCTION(ttiTaskExists)
			INTERNAL_FUNCTION(ttiCreateOrUpdateTask)
			INTERNAL_FUNCTION(ttiUpdateTaskList)
			INTERNAL_FUNCTION(ttiMissionTasks)
			INTERNAL_FUNCTION(ttiMissionBriefing)
			INTERNAL_FUNCTION(ttiUnitTasks)
			INTERNAL_FUNCTION(ttiUnitBriefing)
			INTERNAL_FUNCTION(ttiIsFilter)
			INTERNAL_FUNCTION(ttiIsTaskState)
		};

		class TaskTracker {
			tag="FHQ";
			file="a3_custom\functions\fhq_tasktracker";

			EXPORTED_FUNCTION(ttTaskHint, "This function is called for every task hint to be displayed.")
			EXPORTED_FUNCTION(ttAddBriefing, "Adds a briefing to the missing.")
			EXPORTED_FUNCTION(ttAddTasks, "Adds tasks to the mission.")
			EXPORTED_FUNCTION(ttGetTaskState, "Return the state of a task.")
			EXPORTED_FUNCTION(ttSetTaskState, "Set the new state of a task.")
			EXPORTED_FUNCTION(ttIsTaskCompleted, "Check whether a given task is completed")
			EXPORTED_FUNCTION(ttAreTasksCompleted, "Check whether a list of tasks is completed")
			EXPORTED_FUNCTION(ttIsTaskSuccessful, "Check whether a given task is successfully completed")
			EXPORTED_FUNCTION(ttAreTasksSuccessful, "Check whether a list of tasks is successfully completed")
			EXPORTED_FUNCTION(ttGetAllTasksWithState, "Return an array of all tasks with a given state")
			EXPORTED_FUNCTION(ttSetTaskStateAndNext, "Set a task's state, and select the next one")
		};
	};
};

