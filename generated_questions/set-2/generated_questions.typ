#import "../typst_template.typ": exam-page-setup, exam-title, render-questions
#import "questions_data.typ": questions

#show: exam-page-setup

#exam-title(
  [MS\&E 226 --- Midterm 1 Practice Questions (Generated Set 2)],
  subtitle: [
    16 questions spanning the entire Midterm 1 syllabus (Lectures 2--9 plus
    Problem Set 3 topics: weighted least squares, quantile regression,
    missing-data imputation, log loss, and decision trees). Difficulty is
    calibrated against the office-hours Problem Set 3 practice quiz rather
    than Generated Set 1 -- expect concrete population models, two-statement
    "(i)/(ii), which is correct" evaluations, and transfer/edge-case
    reasoning rather than pure recall. Multiple choice, one correct answer
    among (a)--(d); "(e)" lets you skip a question.
  ],
)

#render-questions(questions)
