#set page(
  width: 84cm, // A1 landscape: 59.4cm x 84.1cm
  height: 59.4cm,
  margin: (top: 0.2cm, bottom: 0cm, left: 3cm, right: 3cm),
)
#set text(size: 24pt)
// #set list(marker: ([•], [$compose$]))
#show heading: it => [
  #set align(center)
  #it
]


#grid(
  columns: (3fr,3fr,3fr),
  gutter: 1cm,
  [
    // --- Phase Retrieval in Holotomography ---
    == Phase Retrieval and Tomography

    - Recover the complex valued refractive object
    $ tilde(O)(x,y,z) =  delta(x, y, z) - "i" beta(x, y, z)  $
    from the measured intensity $cal(I)_(det,phi) (x, y) in RR$.
    - $delta$ describes the phase shift, $beta$ the absorption
    - Angle $phi in [0, pi)$ describes the rotation of the object around the $y$-axis.

  ],
  [
    // --- Forward Model for Fixed Angle ---
    == Forward Model for Fixed Angle
    - Assume $phi = 0$, i.e. the rays are parallel to the $z$-axis.
    - Exiting wave after the object interaction
      $
        Psi_"exit" (tilde(O), Psi_0)(x,y) = exp(-"i" k integral_RR tilde(O)(x,y,z) "d" z) dot Psi_0(x,y)
      $
      - $Psi_0 (x,y)$ the incoming wave field predicted by $"INR"_"Probe"$  // TODO: reformulate
      - $k = 2 pi / lambda$ the wavenumber with wavelength $lambda$

    - Fresnel propagator (non-linear w.r.t. the object $tilde(O)$)$ cal(D)_"Fr" (Psi_"exit") = cal(F)^(-1) (exp(-i pi (k_x^2 + k_y^2) / "Fr") dot cal(F) (Psi_"exit" )) $
      - $cal(F)$ and $cal(F)^(-1)$ denote the Fourier and inverse Fourier transform.
      - Fresnel number $"Fr"$ characterizes the geometry of the experimental setup.
    - Measured intensity at the detector given by $cal(I)_det = abs(cal(D)_"Fr")^2$

  ],
  [

    // --- Loss Function ---
    == Models
    - Hash encoder has 16 levels and hashmap size of $2^21$ and $2^16$ for object and probe
    - MLPs $"INR"_"Sample"$ and $"INR"_"Probe"$ with 4 layers of size 64, and 32, respectively.


    == Loss Function
    $
      L(tilde(O)_"pred", Psi_(0,"pred"), cal(I)_(det,phi), Psi_(0,det)) =& norm(sqrt(cal(I)_(det,phi)) - abs(cal(D)_"Fr" (Psi_"exit" (tilde(O)_"pred", Psi_(0,"pred")))))^2_"L"_2 \
      &+ alpha "softmin"(Psi_(0,"pred"), Psi_(0,det)) \
      &+ beta R_1(tilde(O)_"pred") + gamma R_2(Psi_(0,"pred"))
    $
    - $R_1$ and $R_2$ are regularizers for the object and the probe, weighted by $beta, gamma >0$.
    == Optimization
    - Optimizing model parameters of the $"INRs"$ using AdamW
    - Learning rate scheduler and early stopping

  ]
)

