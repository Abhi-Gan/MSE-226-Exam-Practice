// Shared Typst layout for generated MS&E 226 practice-question sets.
//
// Content (question text, choices, correct answer, explanations) lives in
// a separate data file as an array of dicts -- see output/questions_data.typ
// for the shape expected here. This file only handles formatting, so a new
// question set only needs new data, not new formatting code, and the
// questions/solutions files can never drift out of sync with each other
// (both render from the same array).
//
// Expected shape of one entry in `questions`:
//   (
//     prompt: [... question text, may include math ...],
//     choices: ([choice a], [choice b], [choice c], [choice d]),
//     correct: 0,                         // index into `choices`
//     explanations: ([why a], [why b], [why c], [why d]),  // parallel to choices
//     note: [...],                        // optional: shared lead-in shown
//                                          // before the per-choice breakdown
//                                          // in the solutions render only
//   )

#let letters = ("a", "b", "c", "d", "e", "f")

#let exam-page-setup(body) = {
  set page(width: 8.5in, height: 11in, margin: 1in)
  set text(size: 11pt)
  set par(justify: true)
  body
}

#let exam-title(title, subtitle: none) = [
  #align(center)[
    #text(size: 16pt, weight: "bold")[#title]
    #if subtitle != none [
      #v(4pt)
      #text(size: 10pt)[#subtitle]
    ]
  ]
  #v(16pt)
]

// Renders the question set only: prompts + lettered choices, no answers.
#let render-questions(questions, skip-text: "I choose not to answer this question.") = [
  #for (i, q) in questions.enumerate() [
    == Question #(i + 1)

    #q.prompt

    #v(6pt)
    #for (j, choice) in q.choices.enumerate() [
      (#letters.at(j)) #choice

      #v(6pt)
    ]
    (#letters.at(q.choices.len())) #skip-text

    #v(10pt)
  ]
]

// Renders the answer key: correct letter + per-choice explanation.
#let render-solutions(questions) = [
  #for (i, q) in questions.enumerate() [
    == Question #(i + 1) --- Answer: (#letters.at(q.correct))

    #if "note" in q [
      #q.note

      #v(6pt)
    ]
    #for (j, exp) in q.explanations.enumerate() [
      *(#letters.at(j))* #exp

      #v(6pt)
    ]
    #v(10pt)
  ]
]
