best <- function(state, outcome) {
  ## Read outcome data
  outcomes <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  ## Check that state and outcome are valid
  states <- factor(outcomes$State)
  diseases <- factor(c('heart attack', 'pneumonia', 'heart failure'))
  if(!(state %in% states))
    stop("invalid state")
  if(!(outcome %in% diseases))
    stop("invalid outcome")
  
  ## Return hospital name in that state with lowest 30-day death
  ## rate
  hospitals <- outcomes[,2][outcomes$State == state]
  if(outcome == 'heart attack')
    death = as.numeric(outcomes[,11][outcomes$State == state])
  if (outcome == 'heart failure')
    death = as.numeric(outcomes[,17][outcomes$State == state])
  if (outcome == 'pneumonia')
    death = as.numeric(outcomes[,23][outcomes$State == state])
  hospital.deaths = data.frame(hospitals, death)
  alph.hospital.deaths = hospital.deaths[with(hospital.deaths, order(death, hospitals)), ]
  minimal.hospitals = alph.hospital.deaths[alph.hospital.deaths$death == min(alph.hospital.deaths$death, na.rm = TRUE), 
                                           1]
  result = as.character(minimal.hospitals[!is.na(minimal.hospitals)])
  result             
}