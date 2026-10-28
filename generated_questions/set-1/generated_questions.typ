#import "../typst_template.typ": exam-page-setup, exam-title, render-questions
#import "questions_data.typ": questions

#show: exam-page-setup

#exam-title(
  [MS\&E 226 --- Midterm 1 Practice Questions (Generated Set 1)],
  subtitle: [
    10 questions, deliberately weighted toward Lectures 7--9 (bias-variance
    decomposition, frequentist inference, standard errors \& confidence
    intervals for the sample mean) --- the material with the least existing
    practice-question coverage relative to how much class time it received.
    Multiple choice, one correct answer among (a)--(d); "(e)" lets you skip
    a question, matching last year's exam format.
  ],
)

#render-questions(questions)
