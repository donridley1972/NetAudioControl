  MEMBER('AudioExample.clw')

  PRAGMA('define(init_priority=>3)')

  MAP
    MODULE('AudioExample_BC0.CLW')
AudioExample_BC0:DctInit             PROCEDURE()
AudioExample_BC0:DctKill             PROCEDURE()
AudioExample_BC0:FilesInit           PROCEDURE()
    END
  END

DctInit PROCEDURE()
  CODE
  AudioExample_BC0:DctInit
  AudioExample_BC0:FilesInit


DctKill PROCEDURE()
  CODE
  AudioExample_BC0:DctKill

