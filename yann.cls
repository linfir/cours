% Time-stamp: <2017-09-26 22:37:54 yann>

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{yann}

\DeclareOption*{\ClassError{yann}{Unknown option `\CurrentOption'}}
\ProcessOptions\relax

\LoadClass{scrartcl}

\RequirePackage{yann}
\RequirePackage{geometry}
\RequirePackage{scrpage2}
\RequirePackage{lastpage}
\RequirePackage{ragged2e}
\RequirePackage{multicol}

% -----------------------------------------------------------------------------

\newcommand\yann{\pgfqkeys{/yann}}
\newif\ify@displaystyle
\newif\ify@twocolumn

\yann{
  classe/.store in=\y@classe,
  displaystyle/.is if=y@displaystyle,
  geometry/.code={\geometry{#1}},
  layout/.is choice,
  twocolumn/.is if=y@twocolumn,
  %
  smalllists/.code={\setlist[enumerate]{leftmargin=*}\setlist[itemize]{leftmargin=*}},
  %
  layout/onecolumn/.style={
    twocolumn=false,
    geometry={margin=3cm},
  },
  layout/twocolumn/.style={
    twocolumn=true,
     geometry={margin=1cm,top=2cm,bottom=3cm,foot=1cm},
    smalllists,
  },
  %
  classe=$\Psi$2017--2018,
  layout=twocolumn,
}

% -----------------------------------------------------------------------------

\everymath\expandafter{\the\everymath\ify@displaystyle\displaystyle\fi}

% -----------------------------------------------------------------------------

\let\@author=\relax
\let\@date=\relax
\renewcommand\maketitle{%
    \begin{center}%
        {\sffamily\huge\bfseries\@title}%
        \ifx\@author\relax\else\par\medskip{\itshape\Large\@author}\fi
        \ifx\@date\relax\else\par\bigskip{\large\@date}\fi
    \end{center}\bigskip
    \ify@twocolumn
        \par\begin{multicols*}{2}%
        \AtEndDocument{\end{multicols*}}%
        \setlength{\columnsep}{5mm}
    \fi
}

\clearscrheadfoot
\pagestyle{scrheadings}
\thispagestyle{empty}
\AtBeginDocument{%
  \ohead{\y@classe}%
  \ihead{\thepage/\pageref{LastPage}}}

% -----------------------------------------------------------------------------

\endinput
